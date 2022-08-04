
#!/bin/bash
set -e

# build image
docker-compose build

export AWS_PROFILE=default
export AWS_DEFAULT_REGION=us-east-1

# login to ECR
version=$(aws --version | awk -F'[/.]' '{print $2}')
if [ $version -eq "1" ]; then
  login=$(aws ecr get-login --no-include-email) && eval "$login"
else
  aws ecr get-login-password | docker login --username AWS --password-stdin 656862533084.dkr.ecr.us-east-1.amazonaws.com
fi

# push image to ECR repo
docker-compose push
# deploy image and env vars
fargate service deploy -f docker-compose.yml
