# REPLACE >[DEVELOPMENT_ACCOUNT]<, >[PRODUCTION_ACCOUNT]<, >[ECR_URI_DEVELOPMENT]<, and >[ECR_URI_PRODUCTION]< before running this script!
#!/usr/bin/env bash
# Deployent script DEVELOPMENT or PRODUCTION
# Script is dependent on aws-vault environment variable set to >[DEVELOPMENT_ACCOUNT]< or >[PRODUCTION_ACCOUNT]<

# CUSTOMIZATIONS BEFORE DEPLOEYMENT #
APP='fluffypuppy'
VERSION='0.2'
# END CUSTOMIZATIONS #

DATE=$(date +%s)
ECS_REGION='eu-west-1'
ECR_URI_DEV='>[ECR_URI_DEVELOPMENT]<'
ECR_URI_PROD='>[ECR_URI_PRODUCTION]<'

if [[ $AWS_VAULT = '>[DEVELOPMENT_ACCOUNT]<' ]]
then
  echo 'Building and pushing docker image for' $AWS_VAULT

  (
  cd docker/fluffypuppy
  docker build -t ${APP}:${DATE} .
  cd ../nginx
  docker build -t ${APP}-nginx:${DATE} .
  $(aws ecr get-login --region "${ECS_REGION}")

  # tag to ecr
  docker tag ${APP}:${DATE} ${ECR_URI_DEV}:${APP}-${VERSION}
  docker tag ${APP}-nginx:${DATE} ${ECR_URI_DEV}:${APP}-nginx-${VERSION}

  #push to ecr
  docker push ${ECR_URI_DEV}:${APP}-${VERSION}
  docker push ${ECR_URI_DEV}:${APP}-nginx-${VERSION}
  )

  echo
  echo
  echo
  echo 'Successful deployment to DEVELOPMENT'

elif [[ $AWS_VAULT = '>[PRODUCTION_ACCOUNT]<' ]]
then
  echo 'Building and pushing docker image for' $AWS_VAULT

  (
  cd docker/fluffypuppy
  docker build -t ${APP}:${DATE} .
  cd ../nginx
  docker build -t ${APP}-nginx:${DATE} .
  $(aws ecr get-login --region "${ECS_REGION}")

  # tag to ecr
  docker tag ${APP}:${DATE} ${ECR_URI_PROD}:${APP}-${VERSION}
  docker tag ${APP}-nginx:${DATE} ${ECR_URI_PROD}:${APP}-nginx-${VERSION}

  #push to ecr
  docker push ${ECR_URI_PROD}:${APP}-${VERSION}
  docker push ${ECR_URI_PROD}:${APP}-nginx-${VERSION}
  )

  echo
  echo
  echo
  echo 'Successful deployment to PRODUCTION'

else
  echo "please run 'aws-vault exec >[PRODUCTION_ACCOUNT]<' or (>[DEVELOPMENT_ACCOUNT]<) prior executing the script"
fi
