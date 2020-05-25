#Installing dependencies
#echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
#wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
#sudo apt update

#sudo apt -y install postgresql
#sudo systemctl start postgresql
#sudo systemctl enable postgresql
#echo -e i"dbpassword" | sudo passwd --stdin postgres
#echo 'postgres:newpassword' | chpasswd
#echo -e "linuxpassword\nlinuxpassword" | passwd postgresql
whoami

sudo su - postgres
id -u concourse &>/dev/null || useradd concourse 
psql -U postgres << EOF
ALTER USER concourse WITH ENCRYPTED password 'DBPassword';
CREATE DATABASE concourse OWNER concourse;
EOF
\q
exit
whoami

