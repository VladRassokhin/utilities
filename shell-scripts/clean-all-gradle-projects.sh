#!/bin/bash
dest=${1:-.}
deep=${2:-5}
echo "Cleaning all gradle projects in directory $dest with maxdepth $deep";
find "$dest" -maxdepth "$deep" -type f -name 'build.gradle' -exec bash -c "cd \$(dirname \"{}\") && [[ -d build ]] && echo 'Cleaning {}' && rm -r build" \;
