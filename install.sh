#!/bin/bash

cp ~/scripts/shardeum/config/env.sample ~/scripts/shardeum/config/env

  if [ -f ~/scripts/shardeum/config/env ] 
    then
      echo "Config file found."
    else
      echo "Config file not found, creating one."
      cp ~/scripts/shardeum/config/env.sample ~/scripts/shardeum/config/env
  fi

sudo apt update
apt upgrade -y
sudo apt-get install curl jq
sudo apt install docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
./installer.sh
