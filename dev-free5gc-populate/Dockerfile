# Copyright Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.23 AS builder
ARG COMMIT=0be67ef5d31c2cb175d21fbc215e34a51c0acbb1
RUN : ${COMMIT:? Missing build-arg COMMIT.} &&  git -C /go/src clone --depth 1 --quiet -b f5gc4.0 https://github.com/louisroyer/free5gc-populate free5gc-populate
WORKDIR /go/src/free5gc-populate
RUN mkdir -p /go/bin && go build -o /go/bin/free5gc-populate main.go

FROM louisroyer/base-irit:latest

LABEL maintainer="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.authors="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.source="https://github.com/louisroyer-docker/free5gc-populate"

# Used to disable caching of next steps, if not build since 1 day,
# allowing to search and apply security upgrades
ARG BUILD_DATE=""

RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    wait-for-it \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/free5gc-populate /usr/local/bin/free5gc-populate
COPY ./*.sh /usr/local/bin/
COPY ./template.yaml /usr/local/share/free5gc-populate/
ENV TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/free5gc-populate/config.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/free5gc-populate/template.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
