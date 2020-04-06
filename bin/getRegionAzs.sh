#!/bin/bash

aws ec2 describe-availability-zones --region $2 --profile $1 --query 'AvailabilityZones[*] |  length(@)' --output text