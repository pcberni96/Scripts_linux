#!/bin/bash
cp /etc/named.conf /etc/named.conf.org
cp /etc/named.rfcf1912.zones /etc/named.rfc1912.zones.org

hostnamectl set-hostname "server-dns-apache-db.server"

sed -i '/options {/ a \    listen-on port 53 {127.0.0.1;};' /etc/named.conf

sed -i '/};/ a \     listen-on-v6 port 53 { ::1; };' /etc/named.conf
