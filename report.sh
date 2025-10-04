#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source $path/env

docker exec shardeum-validator operator-cli status >/root/logs/shardeum-status
docker_status=$(docker inspect shardeum-validator | jq -r .[].State.Status)
#folder_size=$(du -hs $HOME/.shardeum | awk '{print $1}')
ext_port=$EXT_PORT
dash_port=$DASH_PORT
server_ip=$SERVER_IP
#ext_port=$(cat ~/.shardeum/.env | grep SHMEXT | cut -d "=" -f 2)
#dash_port=$(cat ~/.shardeum/.env | grep DASHPORT | cut -d "=" -f 2)
#server_ip=$(cat ~/.shardeum/.env | grep SERVERIP | cut -d "=" -f 2)
version=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.appData.shardeumVersion | sed 's/\"//g')
node_status=$(curl -s http://localhost:$ext_port/nodeinfo | jq .nodeInfo.status | sed 's/"//g')
url=http://$server_ip:$dash_port
#rewards=$(docker logs shardeum-validator | grep -a currentRewards | tail -1 | awk '{print $NF}' | sed "s/'//g" | cut -d . -f 1)
state=$(cat /root/logs/shardeum-status | grep state | awk '{print $NF}')
last=$(cat /root/logs/shardeum-status | grep lastActive | awk -F "lastActive: " '{print $NF}' )
rewards=$(cat /root/logs/shardeum-status | grep currentRewards | awk '{print $NF}' | sed "s/'//g" | cut -d . -f 1 )

diff=$(( $(date +%s) - $(date -d "$last" +%s) ))

if [ $diff -lt 86400 ]; then
  last_ago="today"
else
  last_ago="$(( diff / 86400 )) days ago"
fi

cd $path

case $node_status in
 null) status="ok";message=$state ;;
 active) status="ok";message=$state ;;
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
        "network":"mainnet",
        "chain":"shardeum",
        "status":"$status",
        "message":"$message",
        "m2":"state=$state",
        "m1":"rewards=$rewards last=$last",
        "version":"$version",
        "url":"http://$server_ip:$dash_port"
   }
}
EOF

cat $json | jq
