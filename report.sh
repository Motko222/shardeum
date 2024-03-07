#!/bin/bash

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/conf
docker_status=$(docker inspect shardeum-dashboard | jq -r .[].State.Status)
folder_size=$(du -hs $HOME/.shardeum | awk '{print $1}')
ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)

version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
node_status=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')

case $node_status in
 null) status="ok";message="standby ($note_status)" ;;
 active) status="ok";message="active" ;;
 *) status="error";message="API error ($note_status)" ;;
esac

case $docker_status in
  running) ;;
  *) status="error"; message="docker not running" ;;
esac

cat << EOF
{
  "project":"$folder",
  "id":"$ID",
  "machine":"$MACHINE",
  "chain":"sphinx",
  "type":"node",
  "status":"$status",
  "note":"$note",
  "folder_size":"$folder_size",
  "updated":"$(date --utc +%FT%TZ)",
  "docker_status":"$docker_status",
  "node_status":"$node_status",
  "ext_port":"$ext_port",
  "version":"$version",
  "links": { "name":"dash", "url":"https://$server_ip:$dash_port/maintenance" }
}
EOF

if [ ! -z $HOST ]
then
 curl --request POST \
 "$HOST/api/v2/write?org=$ORG&bucket=node&precision=ns" \
  --header "Authorization: Token $TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary '
    status,node=$ID,machine=$MACHINE status="$status",message="$note" $(date +%s%N) 
    '
fi
