#!/bin/bash

#update node
cd ~
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
./installer.sh

#send data to influxdb
if [ ! -z $INFLUX_HOST ]
then

 source ~/.bash_profile

 ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
 dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
 server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)
 url=https://$server_ip:$dash_port
 version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
 id=shardeum-$SHARDEUM_ID
 
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=node&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary '
    update,node='$id',machine='$MACHINE' version="'$version'",url="'$url'" '$(date +%s%N)' 
    '
fi
