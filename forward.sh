#!/bin/bash
set -x

#iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 2612 -j DNAT --to 192.168.255.100:22
#iptables -A FORWARD -p tcp -d 192.168.255.100 --dport 2612 -j ACCEPT

#iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 1234 -j DNAT --to 192.168.255.100:80
#iptables -A FORWARD -p tcp -d 192.168.255.100 --dport 1234 -j ACCEPT

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 2612 -j DNAT --to-destination 192.168.255.100:22
iptables -A FORWARD -p tcp -d 192.168.255.100 --dport 2612 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 1234 -j DNAT --to-destination 192.168.255.100:80
iptables -A FORWARD -p tcp -d 192.168.255.100 --dport 1234 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
