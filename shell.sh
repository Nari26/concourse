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
sudo su - postgres -c "createuser concourse"

sudo su - postgres -c "psql -c \"ALTER USER concourse WITH ENCRYPTED password 'DBPassword';\""

sudo su - postgres -c "psql -c \"CREATE DATABASE concourse OWNER concourse;\""

