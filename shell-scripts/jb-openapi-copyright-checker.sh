#!/bin/bash

[ -z "$1" ] && echo "Specify directory to check" && exit 1

directory="$1"
this_year="$(date +'%Y')"

for i in $(find $directory -type f -name '*.java' | sed -n "s|^${directory}/||p"); do
	[ -z "$i" ] && continue
	if [ ! -f $i ]; then
		echo "Cannot acces file '$i'"
	elif head -2 $i | tail -1 | grep -q 'JetBrains'; then
		head -2 $i | tail -1 | grep -q "2000-${this_year}" || echo -e "\e[33mOutdated copyright in file '$i':\t\t$(head -2 $i|tail -1)\e[0m";
	else
		echo -e "\e[31mNo copyright in file '$i'\e[0m";
	fi
done

