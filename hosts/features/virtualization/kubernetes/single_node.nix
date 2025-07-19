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
        "--disable traefik"
        "--tls-san ${config.networking.hostName}.ko0.net"
    ]);
    clusterInit = true;
    
  };
  networking.firewall = {
    allowedTCPPorts = [
      6443  # Kubernetes API server
      2379 2380  # etcd server client API (for HA setup)
      10250  # kubelet API
      10251  # kube-scheduler
      10252  # kube-controller-manager
    ];
    # allowedUDPPorts = [
    #   8472  # Flannel VXLAN (if using Flannel CNI)
    # ];
  };
}
