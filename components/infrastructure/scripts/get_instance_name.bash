#!/usr/bin/env bash
set -e
# Get the parameters from Terraform
RESOURCE_GROUP=$1
VMSS_NAME=$2
SUBSCRIPTION_ID=$3

# The Terraform task authenticates via ARM_* variables but never runs 'az login'
if ! az account show >/dev/null 2>&1; then
  az login --service-principal \
    --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" \
    --tenant "$ARM_TENANT_ID" >/dev/null
fi

az account set --subscription="$SUBSCRIPTION_ID"
INSTANCE_NAME=$(az vmss list-instances -g "$RESOURCE_GROUP" -n "$VMSS_NAME" --query "sort_by([], &instanceId)[0].osProfile.computerName" -o tsv)

echo -n "{\"instance_name\":\"$INSTANCE_NAME\"}"
