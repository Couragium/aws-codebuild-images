ARG RUST_VERSION="1.52.1"

FROM rust:${RUST_VERSION}-slim AS base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libssl-dev pkg-config && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rustup component add rustfmt

RUN rustup component add clippy

RUN cargo install sccache

RUN cargo install cargo-cache && cargo cache --autoclean

ENV RUSTC_WRAPPER="/usr/local/cargo/bin/sccache"

# Please, set env vars in the buildspec to select your backend.
# More info https://github.com/mozilla/sccache#storage-options
#
# local, not recommended
# SCCACHE_DIR
# SCCACHE_BUCKET
# SCCACHE_CACHE_SIZE
#
# s3
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_IAM_CREDENTIALS_URL
# SCCACHE_ENDPOINT
# SCCACHE_S3_USE_SSL
#
# redis
# SCCACHE_REDIS
#
# memcached
# SCCACHE_MEMCACHED
#
# for orverwriting cache contents
# SCCACHE_RECACHE

FROM base AS packages

RUN set -ex \
    && echo 'Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/99use-gzip-compression \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
          ca-certificates \
          autoconf automake build-essential bzip2 \
          curl expect file g++ gcc gzip iptables jq less \
          libssl-dev locales make netbase openssl \
          patch pkg-config procps rsync stunnel \
          tar unzip wget zip zlib1g-dev \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/* 

RUN useradd codebuild-user


FROM packages AS tools

ARG AWS_IAM_AUTH="https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator"
ARG AWS_CLI="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

RUN curl -sS -o /usr/local/bin/aws-iam-authenticator ${AWS_IAM_AUTH} \
    && chmod +x /usr/local/bin/aws-iam-authenticator

RUN curl ${AWS_CLI} -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /opt \
    && /opt/aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm /tmp/awscliv2.zip \
    && rm -rf /opt/aws \
    && aws --version


FROM tools AS docker

ARG DOCKER_BUCKET="download.docker.com"
ARG DOCKER_CHANNEL="stable"
ARG DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034"
ARG SRC_DIR="/usr/src"

ARG DOCKER_SHA256="ddb13aff1fcdcceb710bf71a210169b9c1abfd7420eeaf42cf7975f8fae2fcc8"
ARG DOCKER_VERSION="19.03.13"

RUN set -ex \
    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
    && rm docker.tgz \
    && docker -v \
    && addgroup dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    && wget -nv "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && chmod +x /usr/local/bin/dind

VOLUME /var/lib/docker


FROM docker AS builder

COPY dockerd-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["dockerd-entrypoint.sh"]
