#!/usr/bin/env bash
export NIX_SSHOPTS="-A"

build_remote=false

hosts="$1"
shift

if [ -z "$hosts" ]; then
    read -p "Host name: " hosts
fi

for host in ${hosts//,/ }; do
    # nixos-rebuild --flake .\#$host switch --target-host $host --use-remote-sudo --use-substitutes $@
    nix flake update
    sudo nixos-rebuild --flake .?submodules=1\#$host switch --use-substitutes $@
done
