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
      inheritParentConfig = true;
      configuration = {
        imports = [ ../features/virtualization/docker/services/drawio.nix ];
        system.nixos.tags = [ "tablet" ];
        # services.cage.enable = true;
      };
    };
  };
}
