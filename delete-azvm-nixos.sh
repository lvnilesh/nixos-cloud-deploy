#! /etc/profiles/per-user/cloudgenius/bin/zsh

set -e

# process command line arguments
VM_NAME=aznix
VM_USERNAME=cloudgenius
LOCATION=westus
VM_KEYNAME=id_ed25519
GITHUB_KEYNAME=id_ed25519
SIZE=Standard_B4ms
MODE=nixos
IMAGE=Canonical:ubuntu-24_04-lts:server:latest # or ARM64: Canonical:ubuntu-24_04-lts:server-arm64:latest
NIX_CHANNEL=nixos-24.05
NIX_CONFIG_REPO=lvnilesh/nix-config

[ -z $RESOURCE_GROUP_NAME ] && RESOURCE_GROUP_NAME=$VM_NAME

# delete Azure RG
az group delete -n $RESOURCE_GROUP_NAME --yes --no-wait
