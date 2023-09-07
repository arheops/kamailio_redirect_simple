#!/bin/bash
IPT="/sbin/iptables"

modprobe ip_conntrack

# Clear all fw rules
$IPT -F
$IPT -X

$IPT -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# accept everything from gw
SIP_GW=`cat /etc/kamailio/local_ips.cfg |grep DEFAULT_G|cut -f 3 -d\/`
$IPT -A INPUT -s $SIP_GW -j ACCEPT


# accept everything from asterisks
for ip in  `cat /etc/kamailio/dispatcher.list |cut -f 2 -d:|grep -v '#'`
do
 $IPT -A INPUT -s $ip -j ACCEPT
done;

#this server and HA second node 
for ip in 137.184.227.237 165.232.145.163
do
 $IPT -A INPUT -s $ip -j ACCEPT
done

#control server access
for ip in us.pro-sip.net pro-sip.net 
do
 $IPT -A INPUT -s $ip -j ACCEPT
done;

#drop any other SIP
$IPT -A INPUT -m udp -p udp --dport 5060 -j DROP
