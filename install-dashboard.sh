#!/bin/bash

cd ~
rm -r .shardeum

curl -O https://raw.githubusercontent.com/shardeum/shardeum-validator/refs/heads/dev/install.sh
chmod +x install.sh
./install.sh
