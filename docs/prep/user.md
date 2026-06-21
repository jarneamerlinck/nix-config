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

Follow [sops generating secrets](../sops.md#generating-secrets)
with the ssh key for the user.

## 3. Add key to sops (Admin)

The admin will add the key to `../../.sops.yaml`

see [sops add key](./sops.md#add-age-key-to-sops)

## 4. Generate user password

```bash
mkpasswd -m sha-512
```
