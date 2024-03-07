#!/bin/bash

cd ~
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
./installer.sh

folder=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$folder/conf

if [ ! -z $HOST ]
then
 curl --request POST \
 "$HOST/api/v2/write?org=$ORG&bucket=node&precision=ns" \
  --header "Authorization: Token $TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary '
    update,node='$ID',machine='$MACHINE' version="'$version'" '$(date +%s%N)' 
    '
fi
