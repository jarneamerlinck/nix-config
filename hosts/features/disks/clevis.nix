{ lib, pkgs, ... }:
{
  # TODO: allow yubi key to decrypt: https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
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
