#!/bin/bash

echo "Establecer Variables correcta a zona geografica"
echo "----------------------------------------------"
export var01=$(locale | grep LC_MESSAGES | cut -c 14-24)
export var02=$(locale | grep LC_MONETARY | cut -c 14-24)
export var03=$(locale | grep LC_NUMERIC | cut -c 14-24)
export var04=$(locale | grep LC_TIME | cut -c 14-24)

echo "Establecer Variables definidas por el usuario"
echo "----------------------------------------------"

export admin_passwd='Pon_tu_password'
export pg_passwd='Pon_tu_password'
export rabbitmq_passwd='Pon_tu_password'

echo "Instalación/Update software requerido "
echo "----------------------------------------------"

yum install epel-release -y
yum install ansible vim wget git python3 -y

#alternatives --set python /usr/bin/python3# Alternativo #

echo "Instalación de Red Hat Ansible"
echo "----------------------------------------------"

mkdir /tmp/tower && cd /tmp/tower

wget https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz

tar xvzf ansible-tower-setup-3.[67].[45]-[123].tar.gz

sed -i '/lc_messages = 'en_US.UTF-8'/ c $var01' ansible-tower-setup-3.[67].[45]-[123]/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_monetary = 'en_US.UTF-8'/ c $var02' ansible-tower-setup-3.[67].[45]-[123]/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_numeric = 'en_US.UTF-8'/ c $var03' ansible-tower-setup-3.[67].[45]-[123]/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_time = 'en_US.UTF-8'/ c $var05' ansible-tower-setup-3.[67].[45]-[123]/roles/postgres/templates/postgresql.conf.j2

sed -i '/admin_password=''/ c admin_password='$admin_passwd''ansible-tower-setup-3.[67].[45]-[123]/inventory 

sed -i '/pg_password=''/ c pg_password='$pg_passwd''ansible-tower-setup-3.[67].[45]-[123]/inventory

sed -i '/rabbitmq_password=''/ c rabbitmq_password='$rabbitmq_passwd''ansible-tower-setup-3.[67].[45]-[123]/inventory

./setup.sh
