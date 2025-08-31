{ lib, pkgs, ... }:
{
  # https://github.com/Yubico/yubioath-flutter
  # https://support.yubico.com/hc/en-us/articles/360016649039-Installing-Yubico-Software-on-Linux
  # https://www.privacyguides.org/articles/2025/03/06/yubikey-reset-and-backup/#step-6-reset-your-yubikeys-openpgp-and-yubihsm-auth-applicationsA
  # https://github.com/NixOS/nixpkgs/issues/389750
  # https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/

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
    libfido2
    tpm2-tss
  ];
}
