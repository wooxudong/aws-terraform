# aws-terraform

A project to learn terraform and aws infra provisioning for fun :)

## Pre-requisite

- pip >= 19.0.3

## Intall

1. install the **oktaauthpy3**
   ```shell
   pip install oktaauthpy3 awscli aws_role_credentials
   ```
2. run the script at root to generate the config file
   ```shell
   ./get-token.sh init
   ```
3. run the script to generate the access key
   ```shell
   ./get-token.sh run
   ```
   the credentials are by default generated and stored at  `~/.aws/credentials`
   by default it is set to use region **ap-southeast-2**(Syndney)
  
