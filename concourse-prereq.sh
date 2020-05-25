#!/bin/bash

#Installing dependencies
echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

# Install and Configure PostgreSQL Database 
sudo apt -y install postgresql
sudo systemctl start postgresql
sudo systemctl enable postgresql
echo 'postgres:newpassword' | chpasswd

# Creating user and database to setup concourse
sudo su - postgres -c "createuser concourse"
sudo su - postgres -c "psql -c \"ALTER USER concourse WITH ENCRYPTED password 'DBPassword';\""
sudo su - postgres -c "psql -c \"CREATE DATABASE concourse OWNER concourse;\""

# Download and Install Concourse CI
sudo wget https://github.com/concourse/concourse/releases/download/v3.10.0/concourse_linux_amd64 -O /usr/bin/concourse
sudo wget https://github.com/concourse/concourse/releases/download/v3.10.0/fly_linux_amd64 -O /usr/bin/fly
sudo chmod +x /usr/bin/concourse /usr/bin/fly
concourse -version
fly -version
