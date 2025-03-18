#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
cd $path

docker stop shardeum-validator
docker rm shardeum-validator

mv ~/.shardeum ~/backup
mv ~/shardeum ~/backup
rm -r $folder
bash ~/scripts/system/influx-delete-id.sh $folder
