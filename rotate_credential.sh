#!/bin/ash

set -e

###### required environment variables ########
# AWS_ACCESS_KEY_ID:
#   Your AWS access key
# AWS_SECRET_ACCESS_KEY:
#   Your AWS secret key
# AWS_ACCOUNT_ID:
#   Your AWS account id
# AWS_DEFAULT_REGION:
#   Your default region.
#   'us-east-1' was set if you don't set region.
# SECRET_NAME:
#   Your Kubernetes's secret name
# SECRET_NAMESPACE:
#   The namespace which secret is created.
#   default namespace is 'default'
################################################

# it set ECR URL
AWS_ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION:-us-east-1}.amazonaws.com"

# it gets ECR password
AWS_ECR_PASSWORD=$(aws ecr get-login-password)

# it deletes ECR login secret
kubectl delete secret \
  --namespace=${SECRET_NAMESPACE:-default} \
  --ignore-not-found \
  ${SECRET_NAME}

# it creates ECR login secret again
kubectl create secret docker-registry \
  --namespace=${SECRET_NAMESPACE:-default} \
  ${SECRET_NAME} \
  --docker-server=${AWS_ECR_URL} \
  --docker-username=AWS \
  --docker-password=${AWS_ECR_PASSWORD}
