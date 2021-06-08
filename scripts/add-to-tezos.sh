#!/usr/bin/env bash
tezos_path=${1:-"../tezos"}

delete_echo() {
  echo "Deleting $1"
  rm -rf "$1"
}

copy_echo() {
  echo "Copying $1 to $2"
  cp -r "$1" "$2"
}

echo "Removing old files from $tezos_path"
delete_echo "$tezos_path/.git-nix"
delete_echo "$tezos_path/nix"
delete_echo "$tezos_path/shell.nix"
delete_echo "$tezos_path/LICENSE.nix.md"
delete_echo "$tezos_path/README.nix.md"

echo patching exclude
echo "\
# nix files that we want to keep
*
!scripts/add-to-tezos.sh
!LICENSE.nix.md
!README.nix.md
!nix
!shell.nix\
" >> ./.git/info/exclude

echo "Patching exclude in tezos"

echo "\
# nix files that we don't want to keep
shell.nix
nix
.git-nix
*.nix.md\
" >> "$tezos_path/.git/info/exclude"

echo "Moving files in place"

copy_echo ./.git ../tezos/.git-nix
copy_echo ./nix ../tezos/nix
copy_echo ./shell.nix ../tezos/shell.nix
