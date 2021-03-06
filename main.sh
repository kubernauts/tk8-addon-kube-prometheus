#!/bin/sh

set -euo pipefail
#set -x

target="./main.yml"
rm "$target"
echo "# Derived from ./manifests" >> "$target"
echo "Creating main.yaml"

for file in $(find ./manifests -type f -name "*.yaml" | sort) ; do
  echo "add " $file
  cat "$file" >> "$target"
  echo " " >> "$target"
  echo "---" >> "$target"
done
