#!/usr/bin/env bash
set -ex
# Get the parameters from Terraform
RESOURCE_GROUP=$1
VMSS_NAME=$2
SUBSCRIPTION_ID=$3

az account set --subscription=$SUBSCRIPTION_ID
INSTANCE_NAME=$(az vmss list-instances -g $RESOURCE_GROUP -n $VMSS_NAME --query "sort_by([], &instanceId)[0].osProfile.computerName" -o tsv)


echo -n "{\"instance_name\":\"$INSTANCE_NAME\"}"
