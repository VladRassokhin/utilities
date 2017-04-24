#!/bin/bash

if [[ $# -lt 1 ]]; then
	echo "Usage $0 <region>"	
	exit 1
fi

which jq >/dev/null || (echo "'jq' reuired";exit 1)
which aws >/dev/null || (echo "'aws' reuired";exit 1)

region="$1"
shift

echo "Fetching snapshots from region $region"
snapshots=($(aws ec2 describe-snapshots --region $region --output json --owner self | jq -r '.Snapshots[].SnapshotId' | sort | uniq))

echo "Snapshots: ${snapshots[*]}"

echo "Fetching snapshots used in images"
used_snapshots=($(aws ec2 describe-images --region $region --output json --owner self | jq -r '.Images[].BlockDeviceMappings[].Ebs.SnapshotId // empty' | sort | uniq))

echo "Used snapsots: ${used_snapshots[*]}"

oldIFS=$IFS IFS=$'\n\t'
unused=($(comm -23 <(echo "${snapshots[*]}") <(echo "${used_snapshots[*]}")))
IFS=$oldIFS

echo "Unused snapshots: ${unused[*]}"

dry="--dry-run"
if [[ "$1" == "mark" ]]; then
	dry="--no-dry-run"
fi

trap 'exit 2' SIGINT SIGTERM
for sn in "${unused[@]}"; do
	echo "Marking $sn to remove"
	aws ec2 create-tags --region $region $dry --tags Key=ToRemove,Value=True --resources $sn
done
