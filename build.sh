#!/usr/bin/env sh

REPOSITORY="couragium/aws-codebuild-images"

RUST_VERSION="1.52.1"


cd debian/slim
docker build \
    --tag  ${REPOSITORY}:slim \
    .
cd "$OLDPWD"

cd debian/slim-rust
docker build \
    --build-arg RUST_VERSION="${RUST_VERSION}" \
    --tag  ${REPOSITORY}:slim-rust \
    --tag  ${REPOSITORY}:slim-rust-${RUST_VERSION} \
    .
cd "$OLDPWD"

cd debian/slim-rust-cache
docker build \
    --build-arg RUST_VERSION="${RUST_VERSION}" \
    --tag  ${REPOSITORY}:slim-rust-cache \
    --tag  ${REPOSITORY}:slim-rust-${RUST_VERSION}-cache \
    .
cd "$OLDPWD"


docker push ${REPOSITORY} --all-tags
