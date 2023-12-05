#!/bin/bash

if [ -d ~/.shardeum ]
then
 read -p "Shardeum node already installed, this action will purge and re-install. Please unstake your tokens. Continue? " sure
 case $sure in
  y,Y)
   echo "Stopping running cointainer..."
   # bash ~/scripts/shardeum/stop.sh
   echo "Removing directory..."
   # rm -r ~/.shardeum
  ;;
  *)
   exit=true
  ;;
  esac
 else
  echo "Shardeum node installation not found."
 fi

if [ $exit ]
then
 echo "Installation cancelled."
else
  if [ -f ~/scripts/shardeum/config/env ] 
    then
      echo "Config file found."
    else
      echo "Config file not found, creating one."
      cp ~/scripts/shardeum/config/env.sample ~/scripts/shardeum/config/env
  fi
  echo "Installing..."
#  sudo apt update
#  apt upgrade -y
#  sudo apt-get install curl jq
#  sudo apt install docker.io
#  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#  sudo chmod +x /usr/local/bin/docker-compose
#  curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
#  chmod +x installer.sh
#  ./installer.sh
fi
