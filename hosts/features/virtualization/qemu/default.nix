{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qemu
    dnsmasq
  ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  services.spice-vdagentd.enable = true;
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
