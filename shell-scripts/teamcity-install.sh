#!/bin/bash
if [ ! -d "$1" ]; then
	echo "No such directory $1"
	exit 1
fi
if [ ! -f "$2" ]; then
	echo "No such file $2"
	exit 1
fi
tar tf "$2" 1>/dev/null || exit 2
tar xf "$2" --strip-components=1 -C "$1" || exit 2

