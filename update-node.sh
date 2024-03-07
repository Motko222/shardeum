#!/bin/bash

cd ~
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
./installer.sh

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/conf

ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)
version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')

if [ ! -z $HOST ]
then
 curl --request POST \
 "$HOST/api/v2/write?org=$ORG&bucket=node&precision=ns" \
  --header "Authorization: Token $TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary '
    update,node='$ID',machine='$MACHINE' version="'$version'" '$(date +%s%N)' 
    '
fi
