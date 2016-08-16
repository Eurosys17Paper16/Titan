#!/bin/bash

echo "8 8 8" > /proc/sys/kernel/printk

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
#echo "Checking if ipv6 is disabled..."
#cat /proc/sys/net/ipv6/conf/eth0/disable_ipv6

rmmod ixgbe

# Example alternate invocations
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 RSS=16,16
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 RSS=16,16 WRR=1,1
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 RSS=8,8 WRR=1,1

#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 VMDQ=8,8
#sudo insmod ixgbe.ko MDD=0,0 MQ=1,1 TSO=1,1 VMDQ=8,8 WRR=1,1
#sudo insmod ixgbe.ko MDD=0,0 MQ=1,1 TSO=1,1 VMDQ=16,16 WRR=1,1
#sudo insmod ixgbe.ko MDD=0,0 MQ=1,1 TSO=1,1 VMDQ=1,1 WRR=1,1
sudo insmod ixgbe.ko MDD=0,0 MQ=1,1 TSO=0,0 VMDQ=1,1 WRR=1,1

#XXX: Outdated invocations because batching wasn't all that helpful
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 XmitBatch=1,1
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 UseSgseg=1,1 DrvGSOSize=1448,1448
#sudo insmod ixgbe.ko MQ=1,1 TSO=1,1 XmitBatch=1,1 UseSgseg=1,1 DrvGSOSize=1448,1448

#sleep 1

ethtool -G p2p1 rx 4096 tx 4096

ethtool -K p2p1 tso off

#sleep 1

sleep 1

#ifconfig eth0 10.42.0.11
ifconfig p2p1 10.10.1.3 netmask 255.255.255.0

# Set the qdisc to SFQ
sudo tc qdisc add dev p2p1 parent :1 sfq perturb 60

sleep 1
echo "Starting test" > /dev/kmsg
