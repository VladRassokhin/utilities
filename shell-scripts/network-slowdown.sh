#!/bin/bash
eth=${1:-lo}
echo "Will slowdown interface $eth"

sudo tc qdisc add dev $eth root handle 1: htb default 12
sudo tc class add dev $eth parent 1:1 classid 1:12 htb rate 128kbps ceil 256kbps
sudo tc qdisc add dev $eth parent 1:12 netem delay 200ms
