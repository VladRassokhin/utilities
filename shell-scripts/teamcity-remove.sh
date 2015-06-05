#!/bin/bash
if [ ! -d "$1" ]; then
	echo "No such directory $1"
	exit 1
fi
pushd "$1" && rm -r $(ls | grep -v 'data'| grep -v 'logs' ) && popd

