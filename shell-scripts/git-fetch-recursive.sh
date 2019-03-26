#!/bin/bash

while [[ $# -gt 0 ]]
do
case $1 in
    -d|--maxdepth)
    depth="$2"
    shift
    ;;
    -p|--path)
    directory="$2"
    shift
    ;;
    *)
    break
    ;;
esac
shift
done

directory=${directory:-.}
depth=${depth:-5}
echo "Updating all git repos in directory $directory with maxdepth $depth";
find "$directory" -maxdepth "$depth" -type d -name '.git' -exec bash -c "cd '{}' && echo 'Updating {}' && git fetch --all --prune" \;
