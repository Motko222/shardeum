#!/bin/bash

cd ~
curl -O https://raw.githubusercontent.com/shardeum/shardeum-validator/refs/heads/itn4/install.sh
chmod +x install.sh
./install.sh
rm install.sh
