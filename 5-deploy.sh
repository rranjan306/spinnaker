#!/bin/bash

#install dependencies
sudo apt update
sudo apt-get -y install redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server.service
sudo systemctl start redis-server.service

SPINNAKER_VERSION=1.31.3
MY_IP=`curl -s ifconfig.co`

printf "MY_IP_ADDRESS ${MY_IP}"

mkdir -p /home/ubuntu/.hal/default/service-settings/
touch /home/ubuntu/.hal/default/service-settings/gate.yml
touch /home/ubuntu/.hal/default/service-settings/deck.yml
sudo hal config version edit --version $SPINNAKER_VERSION
sudo echo "host: 0.0.0.0" |sudo tee \
    /home/ubuntu/.hal/default/service-settings/gate.yml \
    /home/ubuntu/.hal/default/service-settings/deck.yml

sudo hal config security ui edit --override-base-url http://${MY_IP}:9000
sudo hal config security api edit --override-base-url http://${MY_IP}:8084

sudo hal deploy apply
sudo systemctl daemon-reload
sudo hal deploy connect

printf " ------------ \n|Connected To Spinnaker|\n -------------"