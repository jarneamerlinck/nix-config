#!/usr/bin/env bash
export NIX_SSHOPTS="-A"

build_remote=false

hosts="$1"
shift

if [ -z "$hosts" ]; then
    # read -p "Host name: " hosts
    hosts=$(cat /etc/hostname)
fi

for host in ${hosts//,/ }; do
    # nixos-rebuild --flake .\#$host switch --target-host $host --use-remote-sudo --use-substitutes $@
    sudo nixos-rebuild --show-trace --flake .?submodules=1\#$host switch --use-substitutes $@
done
