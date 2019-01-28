#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Expected at least one argument"
	exit 2
fi

src=${1}

if [[ ! $src =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+$ ]]; then
	echo "Source should be 'Owner/Repo'"
	exit 2
fi

dest=${2:-${src#*/}}

git clone "https://github.com/$src" "$dest"
git -C "$dest" remote set-url origin --push "git@github.com:$src.git"
cd "$dest"
