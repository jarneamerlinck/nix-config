# Hosts
## Goal

Copy ssh keys and other remaining items to the newly setup host

## Ssh keys

1. Copy the age key to the user dir for sops

see [sops](./sops.md#new-device-user)

2. Rebuild to apply the ssh keys

> Make sure ssh-agent is not addded in the ssh config
