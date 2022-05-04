#!/bin/bash -xe
# set up AWS ParallelCluster for Relion environment
# @2022.05.04
#
# This script use many useful hacks from ParallelCluster 3.0 workshop
# https://catalog.us-east-1.prod.workshops.aws/workshops/6735ed89-c2de-4180-904c-40ac9fba7419/en-US/
#

#################################################
# set valiables
export PCLUSTER_CLUSTER_NAME=my-relion-cluster
echo "export PCLUSTER_CLUSTER_NAME=${PCLUSTER_CLUSTER_NAME}" |tee -a ~/.bashrc
AWS_REGION=us-east-1
PCLUSTER_VERSION=3.1.3
PCLUSTER_CONFIG_TEMPLATE_NAME=template_pcluster3_relion_cluster.yaml
PCLUSTER_CONFIG_NAME=generated-${PCLUSTER_CONFIG_TEMPLATE_NAME}
PCLUSTER_POST_INSTALL=pcluster_scripts/02.install.relion-dependencies-ubuntu.all.sh
CHECK_INSTANCE_TYPE=g4dn.metal


if [[ -z "${SSH_KEY}" ]]; then
    export SSH_KEY=pcluster-$(uuidgen --random | cut -d'-' -f1)-$(date +%F)
    echo "export SSH_KEY=${SSH_KEY}" |tee -a ~/.bashrc
    SET_SSH_KEY=true
fi
BUCKET_NAME=pcluster-$(date +%F)-$(uuidgen --random | cut -d'-' -f1)
#BUCKET_NAME=pcluster-$(date +%F)
ASSET_BUCKET=s3://ee-assets-prod-us-east-1/modules/6804aca45d0e479f9ed576a8c9999f4f/v1
VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[].VpcId" --region ${AWS_REGION} | jq -r '.[0]')
SUBNET_ID=$(aws ec2 describe-subnets --region=${AWS_REGION} --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId'   | jq -r --arg i $(($RANDOM % 2)) '.[$i|tonumber]')
AZ_ID=$(aws ec2 describe-subnets --subnet-ids ${SUBNET_ID} | jq -r '.Subnets[0].AvailabilityZone')
INSTANCE_OFFERING=$(aws ec2 describe-instance-type-offerings --location-type availability-zone --filters "Name=location,Values=${AZ_ID}" "Name=instance-type,Values=${CHECK_INSTANCE_TYPE}" --region $AWS_REGION)

if [[ "$(echo ${INSTANCE_OFFERING} | grep ${AZ_ID})" = "" ]]; then
    echo "${SUBNET_ID} (${AZ_ID}) is not offering ${CHECK_INSTANCE_TYPE}."
    echo "Please re-run this script."
    exit -1
fi


#################################################
# Generate new key-pair
if [[ -v SET_SSH_KEY ]]; then
    mkdir -p ~/.ssh
    aws ec2 create-key-pair --key-name ${SSH_KEY} --query KeyMaterial --output text --region=${AWS_REGION} > ~/.ssh/${SSH_KEY}
    chmod 600 ~/.ssh/${SSH_KEY}
fi


#################################################
# Generate cluster-config

sed \
    -e "s/{REGION}/${AWS_REGION}/" \
    -e "s/{SSH_KEY}/${SSH_KEY}/" \
    -e "s/{SUBNET_HEAD}/${SUBNET_ID}/" \
    -e "s/{SUBNET_COMPUTE}/${SUBNET_ID}/" \
    -e "s/{BUCKET_NAME}/${BUCKET_NAME}/" \
    ${PCLUSTER_CONFIG_TEMPLATE_NAME} > ${PCLUSTER_CONFIG_NAME}


#################################################
# Prepare configure script for Head/Compute nodes

aws s3 mb s3://${BUCKET_NAME} --region ${AWS_REGION}
aws s3 cp ${ASSET_BUCKET}/scripts/setup/pcluster/3/generic/custom-actions/on-node-configured/on-node-configured.sh .
chmod +x on-node-configured.sh
aws s3 cp on-node-configured.sh s3://${BUCKET_NAME}/
chmod +x ${PCLUSTER_POST_INSTALL}
aws s3 cp ${PCLUSTER_POST_INSTALL} s3://${BUCKET_NAME}/scripts/


#################################################
# Create Cluster

pip3 install aws-parallelcluster==${PCLUSTER_VERSION} --user --quiet
pcluster create-cluster --cluster-name ${PCLUSTER_CLUSTER_NAME} --cluster-configuration ${PCLUSTER_CONFIG_NAME}
#pcluster create-cluster --dryrun true --cluster-name ${PCLUSTER_CLUSTER_NAME} --cluster-configuration ${PCLUSTER_CONFIG_NAME}
