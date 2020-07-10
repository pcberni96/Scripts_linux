#!/bin/bash

echo "Establecer Variables correcta a zona geografica"
echo "----------------------------------------------"
export var01=$(locale | grep LC_MESSAGES | cut -c 14-24)
export var02=$(locale | grep LC_MONETARY | cut -c 14-24)
export var03=$(locale | grep LC_NUMERIC | cut -c 13-23)
export var04=$(locale | grep LC_TIME | cut -c 10-20)

echo "Establecer Variables definidas por el usuario"
echo "----------------------------------------------"

export admin_passwd='Pon_tu_password'
export pg_passwd='Pon_tu_password'
export rabbitmq_passwd='Pon_tu_password'

echo "Instalación/Update software requerido "
echo "----------------------------------------------"

# yum install epel-release -y # #Opcional 
yum install ansible vim wget git python3 -y

#alternatives --set python /usr/bin/python3# Alternativo # #Opcional

echo "Descarga de archivo Ansible"
echo "----------------------------------------------"

mkdir /tmp/tower
cd /tmp/tower
echo $(pwd)
wget https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz

echo "Descomprimiendo archivo .tar"
echo "------------------------------------------------"
tar xvf /tmp/tower/$(ls -a /tmp/tower | grep ansible) -C /tmp/tower

echo "Reemplazando Variables Timezones"
echo "------------------------------------------------"

sed -i '/lc_messages =/ c lc_messages = \'\'$var01'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_monetary =/ c lc_monetary = \'\'$var02'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_numeric =/ c lc_numeric = \'\'$var03'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/roles/postgres/templates/postgresql.conf.j2

sed -i '/lc_time =/ c lc_time = \'\'$var04'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/roles/postgres/templates/postgresql.conf.j2

echo "Reemplazando Variables Passwords"
echo "------------------------------------------------"

sed -i '/admin_password=/ c admin_password=\'\'$admin_passwd'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/inventory

sed -i '/pg_password=/ c pg_password=\'\'$pg_passwd'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/inventory

sed -i '/rabbitmq_password=/ c rabbitmq_password=\'\'$rabbitmq_passwd'\'\' /tmp/tower/$(ls -a /tmp/tower | grep ansible-tower-setup-[34])/inventory

echo "Instalación de Red Hat Ansible"
echo "----------------------------------------------"
cd /tmp/tower
./setup.sh
