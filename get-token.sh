#!/bin/bash

function script_usage() {
  cat <<EOF
Please try to run ./get-token.sh init or ./get-token.sh run
Usage:
    init                  initialize configurations;
    run                   get the token for okta;
EOF
}

config_file="okta-config.txt"

function init_config() {
  if [[ -f $config_file ]]; then
    echo "config file already exists."
    exit 0
  fi

  read -p ">> What is your okta user name? " username
  read -p ">> What is the okta authentication server? " server
  read -p ">> What is the app type? (amazon_aws)? " apptype
  read -p ">> what is the app id? " appid


  touch $config_file

  {
    echo USER_NAME="$username"
    echo SERVER="$server"
    echo APP_TYPE="$apptype"
    echo APP_ID="$appid"
  } >>$config_file

}

function get_token() {
  if [[ ! -f $config_file ]]; then
    echo "config file does not exists. please run ./get_token.sh init command to generate."
  fi

  . ./okta-config.txt

  oktaauthpy3 -s "$SERVER" -u "$USER_NAME" -t "$APP_TYPE" -i "$APP_ID" | aws_role_credentials saml --profile dev --region ap-southeast-2

}



function control_flow() {
  local param
  if [[ $# -eq 0 ]]; then
    script_usage
    exit 1
  fi
  while [[ $# -gt 0 ]]; do
    param="$1"
    shift
    case $param in
    init)
      init_config
      exit 0
      ;;
    run)
      get_token
      exit 0
      ;;
    *)
      echo "Invalid parameter was provided: $param"
      script_usage
      exit 1
      ;;
    esac
  done
}

control_flow "$@"
