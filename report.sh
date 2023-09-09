#!/bin/bash

source ~/config/shardeum.sh

note=""
port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
sts=$(curl -s http://localhost:$port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')
case $sts in
 null) status="ok";note="standby" ;;
 active) status="ok";note="active" ;;
 *) status="error";note="API error" ;;
esac
version=$(curl -s http://localhost:$port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
network="sphinx"
type="validator"
foldersize=$(du -hs $HOME/.shardeum | awk '{print $1}')

echo "updated=$(date +'%Y-%m-%d.%H:%M:%S')"
echo "version='$version'"
echo "status=$status" 
echo "note='$note'"
echo "network=$network"
echo "type=$type"
echo "folder=$foldersize"
echo "id=$id"
