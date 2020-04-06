#!/bin/sh

# Use AWS CLI to get the most recent version of an AMI that
# matches certain criteria. Has obvious uses. Made possible via
# --query, --output text, and the fact that RFC3339 datetime
# fields are easily sortable.

PROFILE=$1
REGION=$2

aws ec2 --region $REGION --profile $PROFILE describe-images \
 --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server* \
 --query 'sort_by(Images,& CreationDate)[-1].[ImageId]' --output text