#!/bin/bash

source ~/scripts/shardeum/config/env

note=""
port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
sts=$(curl -s http://localhost:$port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')
case $sts in
 null) status="ok";note="standby ($sts)" ;;
 active) status="ok";note="active" ;;
 *) status="error";note="API error ($sts)" ;;
esac
version=$(curl -s http://localhost:$port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
network="sphinx"
type="validator"
foldersize=$(du -hs $HOME/.shardeum | awk '{print $1}')

echo "updated='$(date +'%y-%m-%d %H:%M')'"
echo "version='$version'"
echo "status=$status" 
echo "note='$note'"
echo "network=$network"
echo "type=$type"
echo "folder=$foldersize"
echo "id=$id"
echo "statusapi="$sts
