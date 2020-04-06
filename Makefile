ifndef AWS_PROFILE
$(error You must specify AWS_PROFILE parameter)
endif
ifndef ROLE_ARN
$(error You must specify roleArn parameter)
endif
ifndef AWS_KEY_NAME
$(error You must specify KeyName parameter. create your key pair in AWS Console)
endif
ifndef AWS_REGION
$(error You must specify region parameter)
endif
ifndef BUCKET
$(error You must specify BUCKET parameter)
endif

appName?=privoxy
stack_name?=$(appName)-$(AWS_REGION)
AWS_SOURCE_AMI?=$(shell ./bin/detect-ami.sh $AWS_PROFILE $AWS_REGION)
AWS_INSTANCE_TYPE?=t2.micro
NbAzs?=$(shell ./bin/getRegionAzs.sh $AWS_PROFILE $AWS_REGION)
PrivoxyPort?=8118
PrivoxyMinSize?=1
PrivoxyMaxSize?=1
InstanceType?=t2.micro

## Update aws-cli
update-aws-cli:
	pip install awscli --upgrade --user

## Package Cloud Formation template
package: update-aws-cli
	  aws --profile $(AWS_PROFILE) \
		--region $(AWS_REGION) \
	  cloudformation package \
		--template-file stacks/main.yml \
		--s3-bucket $(BUCKET) \
		--output-template-file template-output.yml

## Deploy Cloud Formation stack
deploy: package
	aws --profile $(AWS_PROFILE) \
		--region $(AWS_REGION) \
	  cloudformation deploy \
		--template-file template-output.yml \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
		--role-arn $(ROLE_ARN) \
		--stack-name $(stack_name) \
		--parameter-overrides  \
        	KeyName=$(AWS_KEY_NAME) \
        	AmiId=$(AWS_SOURCE_AMI) \
			InstanceType=$(InstanceType) \
			NumberOfAZs=$(NbAzs) \
			PrivoxyPort=$(PrivoxyPort) \
			PrivoxyMinSize=$(PrivoxyMinSize) \
			PrivoxyMaxSize=$(PrivoxyMaxSize)

## Describe Cloud Formation stack outputs
describe:
	aws --profile $(AWS_PROFILE) \
		--region $(AWS_REGION) \
	  cloudformation describe-stacks \
		--stack-name $(stack_name) \
		--query 'Stacks[0].Outputs[*].[OutputKey, OutputValue]' --output text

## Delete Cloud Formation stack
delete:
	aws --profile $(AWS_PROFILE) \
		--region $(region) \
	  cloudformation delete-stack \
		--stack-name $(stack_name)