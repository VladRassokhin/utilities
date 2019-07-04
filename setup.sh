#!/usr/bin/env bash

dir="$(realpath $(dirname "$0"))"

cd "$dir"
for f in $(ls -A home); do
	unlink "$HOME/$f"
	ln -s "$dir/home/$f" "$HOME/$f"
done

for f in $(ls -A bin); do
	unlink "$HOME/bin/$f"
	ln -s "$dir/bin/$f" "$HOME/bin/$f"
done

