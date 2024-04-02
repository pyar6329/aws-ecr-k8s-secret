#!/bin/bash

set -e

SCRIPT_DIR=$(echo $(cd $(dirname $0) && pwd))

kubectl delete -f ${SCRIPT_DIR}/cronjob.yaml

kubectl delete secret -n ${SECRET_NAMESPACE:-default} ecr-credential

kubectl patch serviceaccount ${SECRET_NAMESPACE:-default} -p '{"imagePullSecrets": []}'
