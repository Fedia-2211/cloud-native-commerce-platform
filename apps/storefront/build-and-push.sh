#!/bin/bash
set -e

AWS_ACCOUNT_ID=176899553634
AWS_REGION=us-east-1
ECR_REPO=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/cloud-native-commerce-platform/saleor-storefront
IMAGE_TAG=$(git rev-parse --short HEAD)

echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Building storefront image..."
docker build -t $ECR_REPO:$IMAGE_TAG -t $ECR_REPO:latest ./apps/storefront/

echo "Pushing to ECR..."
docker push $ECR_REPO:$IMAGE_TAG
docker push $ECR_REPO:latest

echo "Done! Image: $ECR_REPO:$IMAGE_TAG"
