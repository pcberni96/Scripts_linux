#!/bin/bash
cp /etc/named.conf /etc/named.conf.org

sed -i '/options {/ a \    listen-on port 53 {127.0.0.1;};' /etc/named.conf

sed -i '/};/ a \     listen-on-v6 port 53 { ::1; };' /etc/named.conf

sed -i '/recursing";/ a \     allow-query { localhost: 192.168.217.0/24 };' /etc/named.conf 

cat <<EOF> /etc/named.conf
//Forward Zone
zone "server" IN{
	type master;
	file "server.db";
	allow-update { none; };
	allow-query {any; }
};
EOF

cat <<EOF> /etc/named.conf
//Backward Zone
zone "217.168.192.in-addr.arpa" IN{
	type master;
	file "server.rev";
	allow-update { none; };
	allow-query { any;}
}:

cat <<EOF> /var/named/server.db
$TTL 86400
@ IN SOA dns-primary.server admin.server (
	2019061800 ;Serial
	3600 ;Refresh
	1800 ;Retry
	604800 ;Exire
	86400 ;Minimun TTL
)

;Name Server Information
@ IN NS dns-primary.server

;IP for Name Server
dns-primary IN A 192.168.217.

;A Record for IP address to Hostname 
slave IN A 192.168.217.
EOF

cat <<EOF> /var/named/server.rev
$TTL 86400
@ IN SOA dns-primary.server admin.server (
	2019061800 ;Serial
	3600 ;Refresh
	1800 ;Retry
	604800 ;Exire
	86400 ;Minimun TTL
)

;Name Server Information
@ IN NS dns-primary.server

;Reverse lookup for Name Server
10 IN PTR dns-primary.server

;PTR Record IP address to Hostname 
5 IN PTR slave.server
EOF