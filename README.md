# Nixos with flakes
## Deploy on current host
- run following command on a nixos host:

```bash
nix-shell https://github.com/jarneamerlinck/nix-config/tarball/main
```

## Add a new host
1. Make a new folder under ´./hosts´
2. Copy the harware config and adjust
3. Create a new file under `/home/username`
