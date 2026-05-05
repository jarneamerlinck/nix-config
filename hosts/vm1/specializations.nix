{ pkgs, config, ... }:
{
  specialisation = {
    # default = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     system.nixos.tags = [ "default" ];
    #   };
    # };

    tablet = {
      inheritParentConfig = false;
      configuration = {
        imports = [

          ./hardware-configuration.nix

          ../features/disks/boot_1d_btrfs.nix

          ../base
          ../base/users/eragon

          # ../features/disks/wd-decrypt.nix

          ## Display server
          # ../features/desktop/wayland.nix
          ../features/desktop/cage.nix
          ../features/desktop/gtk.nix

          ## Display Managers
          # ../features/desktop/greetd.nix

          ## Desktop environments / Window Managers
          # ../features/desktop/mouse.nix
          # ../features/desktop/pipewire.nix

          ## Services items
          # ../features/services/unattended-upgrades.nix

          ../features/virtualization/docker
          # ../features/virtualization/docker/traefik.nix
          ../features/virtualization/qemu/qemu-guest.nix

          # ../features/desktop/wireshark.nix
        ];
        system.nixos.tags = [ "tablet" ];
        networking = {
          hostName = "vm1";
          useDHCP = true;
          nameservers = [ "1.1.1.1" ];
        };

        system.stateVersion = "25.11";

        # services.cage.enable = true;
      };
    };
  };
}
