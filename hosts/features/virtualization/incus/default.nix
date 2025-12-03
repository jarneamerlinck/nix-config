{ pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = { };
    # preseed = {
    #   networks = [{
    #     config = {
    #       "ipv4.address" = "10.0.100.1/24";
    #       "ipv4.nat" = "true";
    #     };
    #     name = "incusbr0";
    #     type = "bridge";
    #   }];
    #   storage_pools = [{
    #     config = { source = "/var/lib/incus/storage-pools/default"; };
    #     driver = "dir";
    #     name = "default";
    #   }];
    #
    # };
  };

}
