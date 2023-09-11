#!/bin/bash

sudo apt update
apt upgrade -y
sudo apt-get install curl jq
sudo apt install docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
./installer.sh;

FILE=~/config/shardeum.sh
if [ -f "$FILE" ]; then
    echo "$FILE exists, skipping creation..."
else 
    echo "$FILE does not exist, creating..."
    echo "#!/bin/bash" > $FILE
    echo "id=optional" >> $FILE
fi
