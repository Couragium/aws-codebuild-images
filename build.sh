#!/usr/bin/env sh

REPOSITORY="couragium/aws-codebuild-images"

RUST_VERSION="1.51"
RUSTUP_VERSION="1.23.1"
RUSTUP_INIT_SHA256="ed7773edaf1d289656bdec2aacad12413b38ad0193fff54b2231f5140a4b07c5"


cd debian/slim
docker build \
    --tag  ${REPOSITORY}:slim \
    .
cd "$OLDPWD"

cd debian/slim-rust
docker build \
    --build-arg RUST_VERSION="${RUST_VERSION}" \
    --tag  ${REPOSITORY}:slim-rust \
    --tag  ${REPOSITORY}:slim-${RUST_VERSION} \
    .
cd "$OLDPWD"

cd debian/slim-rust-cache
docker build \
    --build-arg RUST_VERSION="${RUST_VERSION}" \
    --tag  ${REPOSITORY}:slim-rust-cache \
    --tag  ${REPOSITORY}:slim-${RUST_VERSION}-cache \
    .
cd "$OLDPWD"


docker push ${REPOSITORY} --all-tags
