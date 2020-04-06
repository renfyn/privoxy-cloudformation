# privoxy-cloudformation

## About

It's an AWS cloudformation stack to create your own privoxy server using spot instance.

## Requirements

You need an [AWS account](https://portal.aws.amazon.com/billing/signup#/start)  
Install Pyhton 3.7 And [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)  
Configure AWS CLI documentation [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
install make

## Deploy Infrastructure

### Configure your AWS Accout

To deploy this stack you need to create some component manually.  
First, you need a [S3 Bucket](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)  
On EC2 service, you need to create a [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to access to your server thought SSH  
Create a role for [cloudformation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-iam-servicerole.html)

### Environment variables

- Requires :

```bash
export AWS_PROFILE=<your aws profile name>
export AWS_REGION=<AWS favorite region code>
export ROLE_ARN=<cloudformation role arn>
export BUCKET=<your S3 bucket>
export AWS_KEY_NAME=<your key pair name>
export AWS_SOURCE_AMI=$(sh ./bin/detect-ami.sh $AWS_PROFILE $AWS_REGION)
export NbAzs=$(sh ./bin/getRegionAzs.sh $AWS_PROFILE $AWS_REGION)
```

- Overloadable :

```bash
# with default values

export appName=privoxy
export stack_name=$(appName)-$(AWS_REGION)
export PrivoxyPort=8118
export PrivoxyMinSize=1
export PrivoxyMaxSize=1
export InstanceType=t2.micro
```

## Installation

```bash
make deploy
make describe
```