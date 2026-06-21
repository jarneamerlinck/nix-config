# Debugging nix flake/nixos

Sites to visit for info

- [search.nixos.org](https://search.nixos.org) (for packages and nixos options)
- [mynixos.com](https://mynixos.com/) (for options in nixos and home manager)

With `nix repl` you can debug nix/nixos a lot easier.

You can debug the flake with

```bash
nix-inspect --expr "builtins.getFlake \"$(pwd)\""
```
