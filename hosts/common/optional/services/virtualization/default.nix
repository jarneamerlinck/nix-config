{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flatpak
    qemu
    distrobox

    quickemu
  ];

  virtualisation.docker = {
    enable = true;
  };

  environment = {
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
      -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
      "$@"
    '')
  };

}
