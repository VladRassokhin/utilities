#!/usr/bin/env bash

rm -rf 'out/'
mkdir -p 'out/providers'
mkdir -p 'out/provisioners'

ls bin | grep -- '-provider-' | awk -F '-' '{$1=$2=""; print substr($0, 3)}' | sed 's/ /-/'> 'out/providers.list'
ls bin | grep -- '-provisioner-' | awk -F '-' '{$1=$2=""; print substr($0, 3)}' | sed 's/ /-/'> 'out/provisioners.list'


echo "Exporting providers"
for i in $(cat 'out/providers.list'); do
    ./bin/terraform schemas -json -indent -type provider "$i" > "out/providers/$i.json";
done

echo "Exporting provisioners"
for i in $(cat 'out/provisioners.list'); do
    ./bin/terraform schemas -json -indent -type provisioner "$i" > "out/provisioners/$i.json";
done

echo "Exporting functions"
./bin/terraform schemas -json -indent functions > "out/functions.json";

echo "All done"
