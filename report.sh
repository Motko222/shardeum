#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile

docker_status=$(docker inspect shardeum-validator | jq -r .[].State.Status)
#folder_size=$(du -hs $HOME/.shardeum | awk '{print $1}')
ext_port=EXT_PORT
dash_port=DASH_PORT
server_ip=SERVER_IP
#ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
#dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
#server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)
version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
node_status=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')
url=http://$server_ip:$dash_port
rewards=$(docker logs shardeum-validator | grep -a currentRewards | tail -1 | awk '{print $NF}' | sed "s/'//g" | cut -d . -f 1)

cd $path

case $node_status in
 null) status="ok";message="standby" ;;
 active) status="ok";message="active" ;;
 #*) status="error";message="API error - $note_status, restarted";./start-node.sh ;;
 *) status="error";message="API error ($note_status)" ;;
esac

case $docker_status in
  running) ;;
  *) status="error"; message="docker not running" ;;
esac

cat >$json << EOF
{ 
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
        "id":"$folder-$ID",
        "machine":"$MACHINE",
        "owner":"$OWNER",
        "grp":"node" 
  },
  "fields": {
        "machine":"$MACHINE",
        "network":"mainnet",
        "chain":"mainnet",
        "status":"$status",
        "message":"$message",
        "m2":"size=$folder_size",
        "m1":"rewards=$rewards",
        "version":"$version",
        "url":"http://$server_ip:$dash_port"
   }
}
EOF

cat $json | jq
