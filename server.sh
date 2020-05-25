#!/bin/bash

sudo mkdir /opt/concourse
sudo ssh-keygen -t rsa -q -N '' -f /opt/concourse/session_signing_key
sudo ssh-keygen -t rsa -q -N '' -f /opt/concourse/tsa_host_key
sudo ssh-keygen -t rsa -q -N '' -f /opt/concourse/worker_key

sudo cp /opt/concourse/worker_key.pub /opt/concourse/authorized_worker_keys

sudo touch /opt/concourse/web.env /opt/concourse/worker.env

echo "CONCOURSE_SESSION_SIGNING_KEY=/opt/concourse/session_signing_key
CONCOURSE_TSA_HOST_KEY=/opt/concourse/tsa_host_key
CONCOURSE_TSA_AUTHORIZED_KEYS=/opt/concourse/authorized_worker_keys
CONCOURSE_POSTGRES_USER=concourse
CONCOURSE_POSTGRES_PASSWORD=DBPassword
CONCOURSE_POSTGRES_DATABASE=concourse
CONCOURSE_BASIC_AUTH_USERNAME=admin
CONCOURSE_BASIC_AUTH_PASSWORD=StrongPass
CONCOURSE_EXTERNAL_URL=http://localhost:8080" | sudo tee -a /opt/concourse/web.env

echo "CONCOURSE_WORK_DIR=/opt/concourse/worker
CONCOURSE_TSA_WORKER_PRIVATE_KEY=/opt/concourse/worker_key
CONCOURSE_TSA_PUBLIC_KEY=/opt/concourse/tsa_host_key.pub
CONCOURSE_TSA_HOST=127.0.0.1" | sudo tee -a /opt/concourse/worker.env

sudo chmod 600 /opt/concourse/*.env
sudo useradd concourse
sudo chown -R concourse:concourse /opt/concourse
sudo touch /etc/systemd/system/concourse-web.service /etc/systemd/system/concourse-worker.service

echo "[Unit]
Description=Concourse CI web server

[Service]
Type=simple
User=concourse
Group=concourse
Restart=on-failure
EnvironmentFile=/opt/concourse/web.env
ExecStart=/usr/bin/concourse web
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=concourse_web

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/concourse-web.service

echo "[Unit]
Description=Concourse CI worker process

[Service]
Type=simple
Restart=on-failure
EnvironmentFile=/opt/concourse/worker.env
ExecStart=/usr/bin/concourse worker
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=concourse_worker

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/concourse-worker.service

sudo systemctl start concourse-web concourse-worker
sudo systemctl enable concourse-worker concourse-web
sudo systemctl status concourse-worker concourse-web
