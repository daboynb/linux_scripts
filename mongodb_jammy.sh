#!/bin/bash
echo "Add mongodb repo on jammy"
wget https://www.mongodb.org/static/pgp/server-4.2.asc
gpg --no-default-keyring --keyring ./temp-keyring.gpg --import server-4.2.asc
gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output mongo.gpg
sudo mv ./mongo.gpg /etc/apt/trusted.gpg.d/
rm temp-keyring.gpg
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" >> /etc/apt/sources.list'
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 871920D1991BC93C
sudo apt update
echo "Completed"