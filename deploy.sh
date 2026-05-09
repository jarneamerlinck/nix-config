#!/usr/bin/env bash
export NIX_SSHOPTS="-A"

build_remote=false


if [ -z "$host" ]; then
    # read -p "Host name: " hosts
    # hosts=$(cat /etc/hostname)
    host="$(hostnamectl hostname)"
fi

nh os switch "$@" -H "$host" .
