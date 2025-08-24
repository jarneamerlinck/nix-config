{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    bootspec.enabled = true;
    initrd.systemd.enable = true;

    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
