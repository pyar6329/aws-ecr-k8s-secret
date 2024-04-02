FROM alpine:3.19

ARG KUBECTL_VERSION="1.29.2"
ARG USER_ID=1000
ARG USER_NAME=ecr
ARG HOME_DIR="/home/ecr"
ARG PROJECT_ROOT="/app"

ENV AWS_DEFAULT_OUTPUT="json"

# download kubectl
RUN set -x && \
  apk add --no-cache --virtual .build-base \
    curl \
    ca-certificates && \
  curl -sL -o /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
  chmod +x /usr/local/bin/kubectl && \
  apk .build-base

# install aws-cli
RUN set -x && \
  apk add --no-cache aws-cli

# add non-root user
RUN set -x && \
  addgroup -g ${USER_ID} -S ${USER_NAME} && \
  adduser -u ${USER_ID} -S -D -G ${USER_NAME} -H -h ${HOME_DIR} -s /bin/ash ${USER_NAME} && \
  mkdir -p ${PROJECT_ROOT} && \
  chown -R ${USER_NAME}:${USER_NAME} ${PROJECT_ROOT}

WORKDIR ${PROJECT_ROOT}
USER ${USER_NAME}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY rotate_credential.sh /usr/local/bin/rotate_credential.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--rotate"]
