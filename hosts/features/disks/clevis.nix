{ lib, pkgs, ... }:
{
  systemd.tpm2.enable = true;
  security.tpm2.enable = true;
  boot.initrd.clevis = {
    enable = true;
  };
  boot.initrd.systemd.services.cryptsetup.enable = true;
  environment.systemPackages = with pkgs; [
    clevis
    tpm2-tools
    cryptsetup
  ];
}
