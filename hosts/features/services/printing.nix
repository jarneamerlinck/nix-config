{ pkgs, lib, ... }:
{
  # needed for printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      epson-escpr2
      epson-escpr
      brlaser
    ];
  };
}
