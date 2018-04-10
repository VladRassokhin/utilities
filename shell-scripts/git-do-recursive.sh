#!/bin/bash
dest=${1:-.}
deep=${2:-5}
shift
shift
echo "Performing operations on git repos in directory $dest with maxdepth $deep";
find "$dest" -maxdepth "$deep" -type d -name '.git' -exec bash -c "cd '{}/..' && echo \"Performing '$*' in \$(pwd)\" && $*" \;
