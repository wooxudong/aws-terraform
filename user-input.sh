#!/bin/bash

read -p ">> What is your okta user name? " username
read -p ">> What is the okta authentication server? " server
read -p ">> What is the app type? (amazon_aws)? " apptype
read -p ">> what is the app id? " appid

output_file="okta-config.txt"
if [[ -f output_file ]]; then
  echo "config file already exists."
fi

touch "$output_file"

{
  echo USER_NAME="$username"
  echo SERVER="$server"
  echo APP_TYPE="$apptype"
  echo APP_ID="$appid"
}  >> $output_file

