{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString ([
        "--write-kubeconfig-mode \"0644\""
        "--cluster-init"
        "--disable servicelb"
        "--disable traefik"
        "--disable local-storage"
    ]);
    clusterInit = true;
    
  };
}
