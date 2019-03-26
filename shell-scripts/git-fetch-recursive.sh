#!/bin/bash

while [[ $# -gt 0 ]]
do
case $1 in
    -d|--maxdepth) depth="$2"; shift ;;
    -p|--path) directory="$2"; shift ;;
    --parallel) parallel="$2"; shift ;;
    *) break ;;
esac
shift
done

directory=${directory:-.}
depth=${depth:-5}
parallel=${parallel:-0}
echo "Updating all git repos in directory $directory with maxdepth $depth";

if [[ "$parallel" -gt 0 ]]; then
	# TODO: Determine parallelness based on cpu count
	find "$directory" -maxdepth "$depth" -type d -name '.git' -print0 | xargs -0 -P $parallel -I{} bash -c "cd '{}' && echo 'Updating {}' && git fetch --all --prune $@" \;
else
	find "$directory" -maxdepth "$depth" -type d -name '.git' -exec bash -c "cd '{}' && echo 'Updating {}' && git fetch --all --prune $@" \;
fi

