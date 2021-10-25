#!/bin/bash
set -x

iptables -t nat -A PREROUTING -p tcp -i eth0 --dport $3 -j DNAT --to-destination "${1}:${2}"
iptables -A FORWARD -p tcp -d $1 --dport $3 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
