#!/bin/bash

#folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
#source ~/scripts/$folder/conf

source ~/.bash_profile

docker_status=$(docker inspect shardeum-dashboard | jq -r .[].State.Status)
folder_size=$(du -hs $HOME/.shardeum | awk '{print $1}')
ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)

version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
node_status=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')
id=shardeum-$SHARDEUM_ID
url=http://$server_ip:$dash_port
chain=sphinx

case $node_status in
 null) status="ok";message="standby" ;;
 active) status="ok";message="active" ;;
 *) status="error";message="API error - $note_status" ;;
esac

case $docker_status in
  running) ;;
  *) status="error"; message="docker not running" ;;
esac

# show json output 
cat << EOF
{
  "project":"$folder",
  "id":"$id",
  "machine":"$MACHINE",
  "chain":"$chain",
  "type":"node",
  "status":"$status",
  "message":"$message",
  "folder_size":"$folder_size",
  "updated":"$(date --utc +%FT%TZ)",
  "docker_status":"$docker_status",
  "node_status":"$node_status",
  "ext_port":"$ext_port",
  "version":"$version",
  "links": { "name":"dash", "url":"$url" }
}
EOF

# send data to influxdb
if [ ! -z $INFLUX_HOST ]
then
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=node&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary '
    status,node='$id',machine='$MACHINE' status="'$status'",message="'$message'",version="'$version'",url="'$url'",chain="'$chain'" '$(date +%s%N)' 
    '
fi
