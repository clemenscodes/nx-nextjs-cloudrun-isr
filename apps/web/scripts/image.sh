#!/bin/sh

APP="web"
DEVELOPMENT_PROJECT="my_dev_gcp_project"
PRODUCTION_PROJECT="my_prod_gcp_project"

ARTIFACT_REGION="europe-west1"
REGISTRY="docker.pkg.dev"
REPO_NAME="docker"
IMAGE_NAME="$APP"
TAG="$(git rev-parse --short HEAD)"

if [ -z "$1" ]; then
    echo "No configuration (development or production) was given" && exit 1
fi

image() {
    CONFIG="$1"
    PROJECT="$2"
    INPUT_IMAGES="$ARTIFACT_REGION-$REGISTRY/$PROJECT/$REPO_NAME/$IMAGE_NAME"
    echo "$INPUT_IMAGES"
    if [ -z "$CI" ]; then
        INPUT_IMAGES=$INPUT_IMAGES INPUT_TAGS=$TAG nx image $APP
    else
        if [ -z "$INPUT_GITHUB_TOKEN" ]; then
            echo "Missing GitHub token"
            exit 1
        fi
        NEXT_PUBLIC_PROJECT_TYPE=$CONFIG nx build $APP --skip-nx-cache
        INPUT_GITHUB_TOKEN=$INPUT_GITHUB_TOKEN INPUT_IMAGES=$INPUT_IMAGES INPUT_TAGS=$TAG nx image $APP --skip-nx-cache
    fi
}

case "$1" in
development) image "$1" "$DEVELOPMENT_PROJECT" ;;
production) image "$1" "$PRODUCTION_PROJECT" ;;
*) echo "Invalid configuration: $1" && exit 1 ;;
esac
