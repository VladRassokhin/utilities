#!/bin/bash
dest=${1:-.}
deep=${2:-5}
shift
shift
echo "Updating all git repos in directory $dest with maxdepth $deep";
find "$dest" -maxdepth "$deep" -type d -name '.git' -exec bash -c "cd \"{}\" && echo 'Cleaning {}' && git gc $*" \;
