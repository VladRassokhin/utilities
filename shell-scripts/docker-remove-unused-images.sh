#!/bin/bash
args="-a"
if [[ $# -gt 0 ]]; then
	args=$*
fi
docker images $args --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi

