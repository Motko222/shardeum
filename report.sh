#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
docker_status=$(docker inspect shardeum-dashboard | jq -r .[].State.Status)
folder_size=$(du -hs $HOME/.shardeum | awk '{print $1}')
ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)

version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
node_status=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')

case $node_status in
 null) status="ok";note="standby ($note_status)" ;;
 active) status="ok";note="active" ;;
 *) status="error";note="API error ($note_status)" ;;
esac

case $docker_status in
  running) ;;
  *) status="error"; note="docker not running" ;;
esac

cat << EOF
{
  "project":"$folder",
  "id":"$SHARDEUM_ID",
  "machine":"$MACHINE",
  "chain":"sphinx",
  "type":"node",
  "status":"$status",
  "note":"$note",
  "folder_size":"$folder_size",
  "updated":"$(date --utc +%FT%TZ)",
  "docker_status":"$docker_status",
  "node_status":"$node_status",
  "port":"$port",
  "version":"$version",
  "links": { "name":"dash", "url":"http://$server_ip:$dash_port/maintenance" }
}
EOF
