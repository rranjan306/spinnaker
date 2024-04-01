#!/bin/bash

set -e

sudo add-apt-repository ppa:openjdk-r/ppa -y

sudo apt-get update
sudo apt-get -y install jq openjdk-11-jdk

curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
sudo bash InstallHalyard.sh ubuntu -y

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker ubuntu

sudo docker run -p 127.0.0.1:9090:9000 -d --name minio1 \
  -e "MINIO_ACCESS_KEY=minioadmin" \
  -e "MINIO_SECRET_KEY=minioadmin" \
  -v /mnt/data:/data \
  minio/minio server /data

sudo apt-get -y install jq apt-transport-https

MINIO_SECRET_KEY="minioadmin"
MINIO_ACCESS_KEY="minioadmin"

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint http://127.0.0.1:9090 \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key

hal config storage edit --type s3