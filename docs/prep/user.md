# Prep: User

## Goal

Create an ssh key + sops + password

## 1. Generate ssh key

Generate the ssh key for the user.
(Should be done by the user itself. Public key can be shared with admin)

```bash
ssh-keygen -o -a 100 -t ed25519 -f ./id_ed25519 -C USERNAME@$HOST
```

## 2. Generate age key

Generate age key from ssh key.

```bash
nix run nixpkgs#ssh-to-age -- -private-key -i ssh_host_ed25519_key > keys.txt
nix shell nixpkgs#age -c age-keygen -y keys.txt
```

Running those 2 commands will do 2 things:

1. Create a `keys.txt` file
2. Print out the public key (similar to line below)
    `age1aykttttttttttttttttttttttttttttttttttttttttttttttttttttttt`

The `keys.txt` is private and should not be shared. (place it under `~/.config/sops/age`)

Public key will be printed and should be shared to the admin of the flake

## 3. Add key to sops (Admin)

The admin will add the key to `../../.sops.yaml`

see [sops add key](./sops.md#add-key-to-sops)

## 4. Generate user password

```bash
mkpasswd -m sha-512
```
