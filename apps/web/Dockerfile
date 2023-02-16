FROM golang:alpine AS gcsfuse

ENV GOPATH /go

RUN apk --update --no-cache add git fuse fuse-dev \
    && GO111MODULE=auto go get -u github.com/googlecloudplatform/gcsfuse

FROM node:16.19-alpine as runner

RUN set -e; \
    apk update && apk add --no-cache --update \
    tini \
    python3 \
    py-crcmod \
    curl \
    fuse \
    bash \
    && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
    && mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xf /tmp/google-cloud-sdk.tar.gz >/dev/null 2>&1 \
    && /usr/local/gcloud/google-cloud-sdk/install.sh --override-components gsutil \
    && apk del --purge apk-tools \
    && rm -rf /var/cache/apk/*

RUN addgroup -g 2000 nodejs \
    && adduser -D -G nodejs -u 2000 nextjs

ENV APP_HOME /app
ENV APP web
ENV PORT 3000
ENV HOST 0.0.0.0
ENV HOSTNAME localhost
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
ENV APP_DIR apps/$APP
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR $APP_HOME

RUN mkdir gcsfuse && chown nextjs:nodejs gcsfuse

USER nextjs

COPY --from=gcsfuse /go/bin/gcsfuse /sbin
COPY --chown=nextjs:nodejs dist/$APP_DIR/.next/standalone ./
COPY --chown=nextjs:nodejs $APP_DIR/scripts/gcsfuse.sh ./

EXPOSE $PORT

# Ensure the script is executable
RUN chmod +x /app/gcsfuse.sh

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
ENTRYPOINT ["/sbin/tini", "--"]

# Pass the startup script as arguments to Tini
CMD ["/app/gcsfuse.sh"]
