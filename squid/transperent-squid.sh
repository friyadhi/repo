#!/bin/bash
apt-get install squid
IP="$(ifconfig | awk '/eth0/,/inet/' | tail -1 | cut -d':' -f2 | awk -F' ' '{print $1}')"
cat > /etc/squid3/squid.conf <<EOF
acl all src all
acl manager proto cache_object
acl localhost src 127.0.0.1/32
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl SSL_ports port 563
acl SSL_ports port 873
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl Safe_ports port 631
acl Safe_ports port 873
acl Safe_ports port 901
acl purge method PURGE
acl CONNECT method CONNECT
icp_access allow localnet
icp_access deny all
http_port 8181
hierarchy_stoplist cgi-bin ?
access_log /var/log/squid/access.log squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern (Release|Packages(.gz)*)$	0	20%	2880
refresh_pattern .		0	20%	4320
acl shoutcast rep_header X-HTTP09-First-Line ^ICY.[0-9]
upgrade_http0.9 deny shoutcast
acl apache rep_header Server ^Apache
acl SSH dst $IP-$IP/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow purge localhost
http_access deny purge
http_access allow localhost
http_access deny all
broken_vary_encoding allow apache
extension_methods REPORT MERGE MKACTIVITY CHECKOUT
hosts_file /etc/hosts
coredump_dir /var/spool/squid
visible_hostname friyadhi.mooo.com
EOF
#referensi https://deviantengineer.com/2014/03/squid-sshtunnel-centos6/
