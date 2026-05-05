{ pkgs, config, ... }:
{
  specialisation = {
    default = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "default" ];
      };
    };

    tablet = {
      inheritParentConfig = true;
      configuration = {
        system.nixos.tags = [ "tablet" ];
        services.cage.enable = true;
      };
    };
  };
}
