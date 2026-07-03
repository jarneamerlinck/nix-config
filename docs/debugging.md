# Debugging nix flake/nixos

Sites to visit for info

- [search.nixos.org](https://search.nixos.org) (for packages and nixos options)
- [mynixos.com](https://mynixos.com/) (for options in nixos and home manager)

With `nix repl` you can debug nix/nixos a lot easier.

You can debug the flake with

```bash
nix-inspect --expr "builtins.getFlake \"$(pwd)\""
```

## CVE issues

When you have issues with builds breaking caused by CVE's you can fix it with

1. Go to [nixpkgs issues](https://github.com/NixOS/nixpkgs/issues)
2. Search for the packages with issues
3. Add the patch

    in `../overlays/default.nix`

    ```ǹix
    pnpm-alias = final: _prev: {
        pnpm_10_29_2 = final.pnpm_10;
    };

    ```
