#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

dir="$(realpath $(dirname "$0"))"

cd "$dir"
for f in $(ls -A home); do
	if [[ ! -L "$HOME/$f" ]]; then
		continue
	fi
	unlink "$HOME/$f"
	ln -s "$dir/home/$f" "$HOME/$f"
done

mkdir -p "$HOME/bin"
for f in $(ls -A bin); do
	unlink "$HOME/bin/$f"
	ln -s "$dir/bin/$f" "$HOME/bin/$f"
done

