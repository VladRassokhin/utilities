#!/bin/bash
git tag --contains $1 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
	git tag --contains $1 | grep -E '[a-z]+/[0-9]+\.[0-9]+' | awk -F / '{print $2}' | sort -h | uniq  | head -20
else
	echo 'No such commit found in repo'
fi

