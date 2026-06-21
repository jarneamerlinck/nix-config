# Sops

## Usage

[Sops](https://github.com/getsops/sops) can be used to encrypt secrets
with the nixos module called: [sops-nix](https://github.com/Mic92/sops-nix).

Deploying a new machine with sops: [nixos with sops](https://nix-community.github.io/nixos-anywhere/howtos/secrets.html).

Opening a sops file is possible if you have generated the sops secret
(see [generating secrets](#generating-secrets)) and added it to the host machine

## New user

1. Create the sops secret with the ssh key (see [generating secrets](#generating-secrets))

2. Add the sops public key to `.sops.yaml`

    Don't forget to add the user to the needed files inside of this file.

3. Reapply the `.sops.yaml`

    Run the command `./docs/reencrypt_sops.sh` from the root of the repo

    > This step is very imporant.
    > If on a new host you get the message key is not accepted to decrypt `/nix/store/**-secrets.yml`,
    > validate that file can be opend with the user that needs to read it
    > and rebuild on the host.

4. Once the host has been deployed add the key to the users folder under

    `~/.config/sops/age/`

## Add age key to sops

To add the key to sops there are a few steps we need to do.

1. Update `.sops.yaml`

    Add user/host to the keys

    ```yaml
    # .sops.yaml
    keys:
      # Users
      - &users:
        - &<username> age00000000000000000000000000000000000000000000000000000000000
      - &hosts:
        - &<hostname> age00000000000000000000000000000000000000000000000000000000001
    ```

    Now add the `creation_rules`

    - host

        ```yaml
        creation_rules:
          - path_regex: hosts/<hostname>/secrets.ya?ml$
            key_groups:
            - age:
              - *<admin_user>
              - *<hostname>
        ```

    - user

        the user file should be readable by
        the user and any host the user will be deployed on.

        ```yaml
        creation_rules:
          - path_regex: hosts/base/users/<username>/secrets.ya?ml$
            key_groups:
            - age:
              - *<username>
              - *<host1>
              - *<host2>
              - *<host3>
        ```

2. Reapply the `.sops.yaml`

    Run the command `./docs/reencrypt_sops.sh` from the root of the repo

    ```bash
    bash ./docs/reencrypt_sops.sh
    ```

    Use devenv shell incase you don't have sops installed

    > This step is very imporant.
    > If on a new host you get the message key is not accepted to decrypt `/nix/store/**-secrets.yml`,
    > validate that file can be opend with the user that needs to read it
    > and rebuild on the host.

## New Host

1. Get host ssh key

    The ssh key should be `$TEMP/etc/ssh/ssh_host_ed25519_key`.

2. Create the sops secret with the ssh key (see [generating secrets](#generating-secrets))

3. Add the sops public key to `.sops.yaml`

## Generating secrets

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
