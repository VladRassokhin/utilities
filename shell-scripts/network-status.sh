#!/bin/bash
eth=${1:-lo}
echo "Will get interface $eth info"

sudo tc -s qdisc ls dev $eth
