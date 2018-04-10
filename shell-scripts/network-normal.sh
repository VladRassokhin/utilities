#!/bin/bash

eth=${1:-lo}
echo "Will reset interface $eth to defaults"

sudo tc qdisc del dev $eth root
