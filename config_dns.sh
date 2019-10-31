#!/bin/bash
cp /etc/named.conf /etc/named.conf.org

sed -i '/listen-on port 53 { 127.0.0.1; };/ c #listen-on port 53 { 127.0.0.1; };' /etc/named.conf

sed -i '/listen-on-v6 port 53 { ::1; };/ c #listen-on-v6 port 53 { ::1; };' /etc/named.conf

sed -i '/allow-query     { localhost; };/ c allow-query { localhost; 192.168.217.0/24; };' /etc/named.conf

cat <<EOF> /etc/named.conf
zone "server" IN{
	type master;
	file "server.db";
	allow-update { none; };
	allow-query {any; }
};

zone "217.168.192.in-addr.arpa" IN{
	type master;
	file "server.rev";
	allow-update { none; };
};
EOF

cat <<EOF>> /var/named/server.db
//Doc Server
\$TTL 86400
@ IN SOA slave01.server. root.server. (
        2019061800 ;Serial
        3600 ;Refresh
        1800 ;Retry
        604800 ;Expire
        86400 ;Minimun TTL
)
@ IN NS slave01.server

@ IN A 192.168.217.129

slave01 IN A 192.168.217.129
EOF


cat <<EOF>> /var/named/server.rev
//Doc rev
\$TTL 86400
@ IN SOA slave01.server. root.server. (
        2019061800 ;Serial
        3600 ;Refresh
        1800 ;Retry
        604800 ;Expire
        86400 ;Minimun TTL
)
@ IN NS slave01.server.

@ IN PTR server.

slave01 IN A 192.168.217.129

129 IN PTR slave01.server.
EOF
