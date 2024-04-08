#!/bin/bash

set -e

SCRIPT_DIR=$(echo $(cd $(dirname $0) && pwd))

kubectl apply -f ${SCRIPT_DIR}/cronjob.yaml

kubectl create secret generic \
  -n ecr-rotation \
  --dry-run=client \
  ecr-credential \
  --from-literal=AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --from-literal=AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  --from-literal=AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} \
  --from-literal=AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
  --from-literal=SECRET_NAMESPACE=${SECRET_NAMESPACE:-default} \
  -o yaml | kubectl apply -f -

kubectl label secret -n ecr-rotation ecr-credential "app=ecr-credential"

kubectl patch serviceaccount ${SECRET_NAMESPACE:-default} -p '{"imagePullSecrets": [{"name": "ecr-credential"}]}'

# cronjob was run at first immediately
kubectl create job ecr-rotation-first-run --from=cronjob/ecr-credential -n ecr-rotation
