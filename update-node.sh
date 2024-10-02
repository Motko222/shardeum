#!/bin/bash

cd ~
rm -r .shardeum
wget https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh -O installer.sh
bash installer.sh
rm installer.sh
