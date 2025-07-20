# Sops

## Usage

[Sops](https://github.com/getsops/sops) can be used to encrypt secrets 
with the nixos module called: [sops-nix](https://github.com/Mic92/sops-nix).


Deploying a new machine with sops: [nixos with sops](https://nix-community.github.io/nixos-anywhere/howtos/secrets.html).

Opening a sops file is possible if you have generated the sops secret (see [generating secrets](./sops.md#generating-secrets))
and added it to the host machine

## New user

1. Generate a ssh key

`ssh-keygen -o -a 100 -t ed25519 -f ./id_ed25519 -C $USER@$HOST`

2. Create the sops secret with the ssh key (see [generating secrets](./sops.md#generating-secrets))

3. Add the sops public key to `.sops.yaml`

Don't forget to add the user to the needed files inside of this file.

4. Reapply the `.sops.yaml`

Run the command `./docs/reencrypt_sops.sh` from the root of the repo

> This step is very imporant. If on a new host you get the message key is not accepted to decrypt `/nix/store/**-secrets.yml`, validate that file can be opend with the user run this file and rebuild on the host.

5. Once the host has been deployed add the key to the users folder under
    `~/.config/sops/age/`


## New Host

1. Get host ssh key

The ssh key should be `$temp/etc/ssh/ssh_host_ed25519_key`.

2. Create the sops secret with the ssh key (see [generating secrets](./sops.md#generating-secrets))

3. Add the sops public key to `.sops.yaml`


## Generating secrets

The secrets can be generated with:

```bash
nix run nixpkgs#ssh-to-age -- -private-key -i ssh_host_ed25519_key > keys.txt
nix shell nixpkgs#age -c age-keygen -y keys.txt
```

Running those 2 commands will do 2 things:

1. Create a `keys.txt` file
2. Print out the public key (similar to line below)
    `age1aykttttttttttttttttttttttttttttttttttttttttttttttttttttttt`

## New device user

Run the following commands for the new user on a device.

```bash
mkdir -p ~/.config/sops/age
```

then copy the `age.txt` file to that directory
