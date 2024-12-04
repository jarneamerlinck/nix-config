# User

## Change password

To change the password it needs to be added to sops

The hash can be created with the following code

```bash
mkpasswd -m sha-512
```

## Add a new user

1. Add user to sops

see [sops](./sops.md#new-user) for how to.

2. Create a folder for home manager

To create a new user a new directory has to be made under `home`
For a new user called `jarne` it's home manager structure would look like this

```text
|-- home
|   `-- jarne
|       |-- common
|       |-- features
|       |   |-- cli
|       |   |-- desktop
|       |   |   |-- common
|       |   |   |-- gnome
|       |   `   |-- sway
|       |-- ssh.pub
|       `-- host2.nix
```

3. Add a folder under `hosts/common/users`

This containes the user module with a user specific secret sops file.

4. Add the user module to the required machine(s)

```nix
    ../common/users/jarne
```
