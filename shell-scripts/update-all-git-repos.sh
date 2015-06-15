#!/bin/bash
dest=${1:-.}
deep=${2:-5}
echo "Updating all git repos in directory $dest with maxdepth $deep";
find $dest -type d -name '.git' -maxdepth 6 -exec bash -c "cd {}; echo 'Updating {}';git fetch --all --prune" \;
