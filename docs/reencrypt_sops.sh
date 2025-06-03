#!/usr/bin/env bash


# Find all .yml files in the repo
FILES=$(find . -type f -name "*secrets.yml")

for file in $FILES; do
  echo "Re-encrypting $file ..."

  decrypted=$(mktemp)
  sops --decrypt $file > $decrypted

  mv $decrypted $file
  sops -i --encrypt $file

done

echo "All .yml files re-encrypted with updated SOPS config."
