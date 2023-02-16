#!/bin/sh

set -e

export TF_IN_AUTOMATION=true

APP="web"
DEVELOPMENT_PROJECT=""
PRODUCTION_PROJECT=""

APP_DIR="apps/$APP"
PLAN="plan.tfplan"
ARTIFACT_REGION="europe-west1"
REGISTRY="docker.pkg.dev"
REPO_NAME="docker"
IMAGE_NAME="web"
IMAGE_COUNT_THRESHOLD=1
PUBLIC="dist/$APP_DIR/public"
STATIC="dist/$APP_DIR/.next/static"
PURPLE="\\033[0;35m"
SET="\\033[0m\\n"

if [ -z "$1" ]; then
    echo "No configuration (development or production) was given" && exit 1
fi

deploy() {
    CONFIG="$1"
    PROJECT="$2"
    TF_DIR="$APP_DIR/infra/$CONFIG"
    TF="terraform -chdir=$TF_DIR"
    BACKEND="$TF_DIR/backend.tf"
    SHA="$(git rev-parse --short HEAD)"
    REPO="$ARTIFACT_REGION-$REGISTRY/$PROJECT/$REPO_NAME"
    IMAGE="$REPO/$IMAGE_NAME"
    TAGGED_IMAGE="$IMAGE:$SHA"
    BACKEND_ARG="-backend-config=bucket=$APP-$CONFIG-state"
    PLAN_ARG="-out=$PLAN"
    INPUT_ARG="-input=false"
    LOCK_ARG="-lock=false"
    LOCK_TIMEOUT_ARG="-lock-timeout=60s"
    VAR_ARG="-var=git_commit_sha=$SHA"
    TARGET_ARG="-target=module.app"
    APPROVE_ARG="-auto-approve"
    DEFAULT_PLAN="$PLAN_ARG $INPUT_ARG $LOCK_TIMEOUT_ARG $LOCK_ARG $VAR_ARG"
    ARTIFACT_PLAN="$TARGET_ARG $DEFAULT_PLAN"
    APPLY_ARGS="$INPUT_ARG $APPROVE_ARG $LOCK_ARG $LOCK_TIMEOUT_ARG $PLAN"
    if grep -q "local" "$BACKEND"; then
        local_plan
    else
        remote_plan
    fi
    rm "$TF_DIR/$PLAN"
    cleanup
    upload_assets_to_cdn "$PROJECT"
    generate_cdn_dns_entry
    generate_domain_mapping_dns_entry
}

local_plan() {
    $TF init
    artifact_plan
    push_image
    $TF init
    default_plan
    sed -i 's/local/gcs/g' "$BACKEND"
    echo "Migrating state"
    echo "yes" | $TF init "$BACKEND_ARG"
}

remote_plan() {
    $TF init "$BACKEND_ARG"
    artifact_plan
    push_image
    $TF init "$BACKEND_ARG"
    default_plan
}

artifact_plan() {
    TF_COMMAND="$TF plan $ARTIFACT_PLAN"
    run_tf_command
    TF_COMMAND="$TF apply $APPLY_ARGS"
    run_tf_command
}

default_plan() {
    TF_COMMAND="$TF plan $DEFAULT_PLAN"
    run_tf_command
    TF_COMMAND="$TF apply $APPLY_ARGS"
    run_tf_command
}

run_tf_command() {
    echo
    purple "$TF_COMMAND"
    echo
    eval "$TF_COMMAND"
}

push_image() {
    echo "Pushing image $TAGGED_IMAGE to Artifact Registry"
    docker push "$TAGGED_IMAGE"
}

purple() {
    printf "$PURPLE%s$SET" "$1"
}

cleanup() {
    purple "Cleaning up, image threshold: $IMAGE_COUNT_THRESHOLD"
    IMAGES=$(gcloud artifacts docker images list "$REPO" --include-tags --sort-by=CREATE_TIME | tail -n +2)
    echo "$IMAGES"
    IMAGE_COUNT=$(echo "$IMAGES" | wc -l | tr -d ' ')
    i="$IMAGE_COUNT_THRESHOLD"
    while [ $i -lt "$IMAGE_COUNT" ]; do
        DIGEST=$(echo "$IMAGES" | sed -n "${i}p" | awk '{print $2}')
        purple "gcloud artifacts docker images delete $IMAGE@$DIGEST"
        echo "" | gcloud artifacts docker images delete "$IMAGE@$DIGEST" --delete-tags || exit 1
        i=$((i + 1))
    done
}

upload_assets_to_cdn() {
    PROJECT_ID="$1"
    BUCKETS="$(gsutil ls -p "$PROJECT_ID")"
    echo "Buckets: $BUCKETS"
    FULL_BUCKET_ADDRESS="$(echo "$BUCKETS" | grep cdn)"
    echo "Full: $FULL_BUCKET_ADDRESS"
    BUCKET="$(echo "$FULL_BUCKET_ADDRESS" | awk -F '/' '{print $3}')"
    echo "Bucket: $BUCKET"
    BUCKET_ADDRESS="gs://$BUCKET"
    echo "Bucket address: $BUCKET_ADDRESS"
    PUBLIC_BUCKET_ADDRESS="$BUCKET_ADDRESS/public"
    echo "Public: $PUBLIC_BUCKET_ADDRESS"
    STATIC_BUCKET_ADDRESS="$BUCKET_ADDRESS/_next/static"
    echo "Static: $STATIC_BUCKET_ADDRESS"
    upload_static
    upload_public
}

upload_static() {
    echo "Uploading static assets to $STATIC_BUCKET_ADDRESS"
    gsutil -m rsync -u -r "$STATIC" "$STATIC_BUCKET_ADDRESS"
}

upload_public() {
    echo "Uploading public assets to $PUBLIC_BUCKET_ADDRESS"
    gsutil -m rsync -u -r "$PUBLIC" "$PUBLIC_BUCKET_ADDRESS"
}

generate_cdn_dns_entry() {
    DOMAIN=$($TF output domain | tr -d '"')
    SUBDOMAIN=$($TF output subdomain | tr -d '"')
    VALUE=$($TF output ip | tr -d '"')
    echo "The following DNS entry needs to be added to the domain $DOMAIN, so that the CDN works"
    echo "Type:  A"
    echo "Host:  $SUBDOMAIN"
    echo "Value: $VALUE"
}

generate_domain_mapping_dns_entry() {
    DOMAIN=$($TF output domain | tr -d '"')
    SUBDOMAIN=$($TF output cloud_run_subdomain | tr -d '"')
    VALUE="ghs.googlehosted.com."
    echo "The following DNS entry needs to be added to the (verified!) domain $DOMAIN, so that the Cloud Run domain mapping works"
    echo "Type:  CNAME"
    echo "Host:  $SUBDOMAIN"
    echo "Value: $VALUE"
}

case "$1" in
development) deploy "$1" "$DEVELOPMENT_PROJECT" ;;
production) deploy "$1" "$PRODUCTION_PROJECT" ;;
*) echo "Invalid configuration: $1" && exit 1 ;;
esac
