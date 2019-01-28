#!/bin/bash
args="-a"
if [[ $# -gt 0 ]]; then
	args=$*
fi

docker ps $args | awk '{print $1}' | tail -n +2 | xargs -n 1 docker rm
