{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
  ];
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  # programs.virt-manager.enable = true; # for 23.11 or after
  services.spice-vdagentd.enable = true;
}
