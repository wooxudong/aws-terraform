#!/bin/bash

OKTA_USERNAME=xudong.wu@thoughtworks.com
OKTA_APP_ID=exk1c9mun89ywbfHW0h8
OKTA_SERVER=thoughtworks.okta.com
OKTA_APPTYPE=amazon_aws

function script_usage() {
  cat <<EOF
    ./get-token.sh init or ./get-token.sh run
Usage:
    init                  initialize configurations;
    run                   get the token for okta;
EOF
}

config_file="okta-config.txt"
function init_config() {
  read -p ">> What is your okta user name? " username
  read -p ">> What is the okta authentication server? " server
  read -p ">> What is the app type? (amazon_aws)? " apptype
  read -p ">> what is the app id? " appid

  if [[ -f $config_file ]]; then
    echo "config file already exists."
  fi

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


}

function parse_params() {
  local param
  while [[ $# -gt 0 ]]; do
    param="$1"
    shift
    case $param in
    init)
      init_conif
      exit 0
      ;;
    run)
      get_token
      exit 0
      ;;
    *)
      script_exit "Invalid parameter was provided: $param" 1
      ;;
    esac
  done
}

access_key=$(oktaauthpy3 –u "$OKTA_USERNAME" –s "$OKTA_SERVER" –t "$OKTA_APPTYPE" –i "$OKTA_APP_ID")

echo "$access_key"
