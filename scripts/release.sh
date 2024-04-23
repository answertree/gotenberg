#!/bin/bash

set -e

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/b3o6i8i6


GOLANG_VERSION="1.21"
GOTENBERG_USER_GID="1001"
GOTENBERG_USER_UID="1001"
NOTO_COLOR_EMOJI_VERSION="v2.042"
PDFTK_VERSION="v3.3.3"
DOCKER_REPOSITORY="public.ecr.aws/b3o6i8i6/answertree"

GOTENBERG_VERSION="8.4.0"

docker buildx build \
  --build-arg GOLANG_VERSION="$GOLANG_VERSION" \
  --build-arg GOTENBERG_VERSION="$GOTENBERG_VERSION" \
  --build-arg GOTENBERG_USER_GID="$GOTENBERG_USER_GID" \
  --build-arg GOTENBERG_USER_UID="$GOTENBERG_USER_UID" \
  --build-arg NOTO_COLOR_EMOJI_VERSION="$NOTO_COLOR_EMOJI_VERSION" \
  --build-arg PDFTK_VERSION="$PDFTK_VERSION" \
  --platform linux/arm64 \
  -t "$DOCKER_REPOSITORY/gotenberg:latest" \
  -t "$DOCKER_REPOSITORY/gotenberg:8" \
  --push \
  -f build/Dockerfile .

#  --platform linux/amd64 \


# Cloud Run variant.
# Only linux/amd64! See https://github.com/gotenberg/gotenberg/issues/505#issuecomment-1264679278.
# docker buildx build \
#   --build-arg DOCKER_REPOSITORY="$DOCKER_REPOSITORY" \
#   --build-arg GOTENBERG_VERSION="$GOTENBERG_VERSION" \
#   --platform linux/amd64 \
#   -t "$DOCKER_REPOSITORY/gotenberg:latest-cloudrun" \
#   -t "$DOCKER_REPOSITORY/gotenberg:${SEMVER[0]}-cloudrun" \
#   -t "$DOCKER_REPOSITORY/gotenberg:${SEMVER[0]}.${SEMVER[1]}-cloudrun" \
#   -t "$DOCKER_REPOSITORY/gotenberg:${SEMVER[0]}.${SEMVER[1]}.${SEMVER[2]}-cloudrun" \
#   --push \
#   -f build/Dockerfile.cloudrun .