#!/bin/sh

function usage_docs {
  echo ""
  echo "- uses: telia-actions/aws-s3-action@v1.0.0"
  echo "  with:"
  echo "    command: cp ./local_file.txt s3://yourbucket/folder/local_file.txt"
  echo "    aws_access_key_id: \${{ secret.AWS_ACCESS_KEY_ID }}"
  echo "    aws_secret_access_key: \${{ secret.AWS_SECRET_ACCESS_KEY }}"
  echo ""
}

function get_configuration_settings {
  if [ -z "$INPUT_AWS_ACCESS_KEY_ID" ]
  then
    echo "AWS Access Key Id was not found. Using configuration from previous step."
  else
    aws configure set aws_access_key_id "$INPUT_AWS_ACCESS_KEY_ID"
  fi

  if [ -z "$INPUT_AWS_SECRET_ACCESS_KEY" ]
  then
    echo "AWS Secret Access Key was not found. Using configuration from previous step."
  else
    aws configure set aws_secret_access_key "$INPUT_AWS_SECRET_ACCESS_KEY"
  fi

  if [ -z "$INPUT_AWS_SESSION_TOKEN" ]
  then
    echo "AWS Session Token was not found. Using configuration from previous step."
  else
    aws configure set aws_session_token "$INPUT_AWS_SESSION_TOKEN"
  fi

  if [ -z "$INPUT_METADATA_SERVICE_TIMEOUT" ]
  then
    echo "Metadata service timeout was not found. Using configuration from previous step."
  else
    aws configure set metadata_service_timeout "$INPUT_METADATA_SERVICE_TIMEOUT"
  fi

  if [ -z "$INPUT_AWS_REGION" ]
  then
    echo "AWS region not found. Using configuration from previous step."
  else
    aws configure set region "$INPUT_AWS_REGION"
  fi
}

function main {
  echo "v1.0.0"
  get_configuration_settings

  aws --version

  echo aws s3api $INPUT_COMMAND $INPUT_FLAGS
  echo "::set-output name=stdout::$(aws s3api $INPUT_COMMAND $INPUT_FLAGS)"
  echo "::set-output name=rc::$(echo $?)"
}

main
