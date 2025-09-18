#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: ./initial-setup.sh <aws-vault-profile> <environment> <region>"
  exit 1
fi

PROFILE="$1"
ENVIRONMENT="$2"
REGION="$3"
TFVARS_FILE="terraform.tfvars" # Adjust path as needed

echo "Authenticating with AWS using aws-vault profile: $PROFILE"
aws-vault exec "$PROFILE" -- bash <<EOF
  BUCKET_NAME="${ENVIRONMENT}-terraform-state-$(date +%s)"
  DYNAMODB_TABLE="${ENVIRONMENT}-terraform-lock-table-$(date +%s)"
  STATE_KEY="global/s3/terraform.tfstate"

  echo "Creating S3 bucket: \$BUCKET_NAME in region: $REGION"
  aws s3api create-bucket --bucket "\$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION"

  echo "Enabling versioning on S3 bucket: \$BUCKET_NAME"
  aws s3api put-bucket-versioning --bucket "\$BUCKET_NAME" --versioning-configuration Status=Enabled

  echo "Creating DynamoDB table for state locking: \$DYNAMODB_TABLE"
  aws dynamodb create-table \
    --table-name "\$DYNAMODB_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION"
EOF