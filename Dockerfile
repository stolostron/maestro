FROM registry.ci.openshift.org/stolostron/builder:go1.23-linux AS builder

ENV SOURCE_DIR=/maestro
WORKDIR $SOURCE_DIR
COPY . $SOURCE_DIR

ENV GOFLAGS=""
RUN make binary BUILD_OPTS="-tags kafka"

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN microdnf update -y && \
    microdnf install -y util-linux && \
    microdnf clean all

COPY --from=builder maestro/maestro /usr/local/bin/

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/maestro", "server"]

LABEL name="maestro" \
      vendor="Red Hat, Inc." \
      version="0.0.1" \
      summary="maestro API" \
      description="maestro API" \
      io.k8s.description="maestro API" \
      io.k8s.display-name="maestro" \
      io.openshift.tags="maestro"
