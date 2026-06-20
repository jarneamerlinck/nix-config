# Prep: Host

## Goal

Final result should be

- repo (hosts)

    ```text
    hostname
    ├── default.nix
    ├── hardware-configuration.nix
    ├── secrets.yml
    └── ssh_host_ed25519_key.pub
    ```

- repo (home)

    ```text
    home
    └── eragon
        └── hostname
           └── default.nix
    ```

- installation folder  (folder `$TEMP`)
    disk.key is only needed if you do disk encryption

    ```text
    hostname
    ├── disk.key
    └── etc
        └── ssh
            ├── [-rw-------]  ssh_host_ed25519_key
            └── [-rw-r--r--]  ssh_host_ed25519_key.pub
    ```

## 1. Repo prep

1. Make a new folder under ´./hosts´

    1. Generate a ssh key for the new host

        or get it from a vault (see [nixos-anywhere vaults](https://nix-community.github.io/nixos-anywhere/howtos/secrets.html#example-decrypting-an-openssh-host-key-with-pass))

        `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C root@$HOST`

    2. Put the ssh key in the following folder structure on the host

        `"$TEMP/etc/ssh/ssh_host_ed25519_key"`

    3. Set the correct permissions for the host

        Private key: 600
        Public key: 644

        ```bash
        chmod 600 ssh_host_ed25519_key
        chmod 644 ssh_host_ed25519_key.pub
        ```

    4. add the `ssh_host_ed25519_key.pub` in `hosts/{hostname}/ssh_host_ed25519_key.pub`

    5. [sops new host](./sops.md#new-host)

2. Copy the harware config and adjust

3. Create a new file under `/home/username`

4. (optional) docker

if docker will be enabled on the host make sure that the `hostname.domain` resolves to the host.
As docker will automaticly add traefik

This also needs a few params in the sops file for the host (under `./hosts/{hostname}/secrets.yml`)

```yml
traefik:
    env: |
        CF_API_EMAIL=email
        CF_DNS_API_TOKEN=token
```

## 5. Allow other hosts to ssh into it

If the host is a server that others need to ssh into you need to add it to the list in `../home/eragon/features/cli/ssh.nix`
