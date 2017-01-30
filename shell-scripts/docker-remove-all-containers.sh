#!/bin/bash
if [ $# > 0 ]; then
	args=$*
else
	args='-a'
fi

docker ps $args | awk '{print $1}' | tail -n +2 | xargs -n 1 docker rm
