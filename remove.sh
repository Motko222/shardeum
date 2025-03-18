#!/bin/bash

docker stop shardeum-validator
docker rm shardeum-validator

mv ~/.shardeum ~/backup
mv ~/shardeum ~/backup
rm -r $folder
bash ~/scripts/system/influx-delete-id.sh $folder
