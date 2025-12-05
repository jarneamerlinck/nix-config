{ pkgs, ... }:

{
  # for webui seee: https://blog.simos.info/how-to-install-and-setup-the-incus-web-ui/#prerequisites
  # environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    # preseed = { };
    preseed = {
      networks = [
        {
          config = {
            "ipv4.address" = "auto";
            "ipv4.nat" = "true";
          };
          name = "incusbr0";
          type = "bridge";
        }
      ];
      storage_pools = [
        {
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "btrfs";
          name = "default";
        }
      ];

    };
  };

}
