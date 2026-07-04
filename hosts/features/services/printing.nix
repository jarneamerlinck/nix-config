{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cups
    avahi
  ];
  services.ipp-usb.enable = true;
  # needed for printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    browsing = true;
    drivers = with pkgs; [
      # see https://wiki.nixos.org/wiki/Printing#Adding_printers
      cups-filters
      cups-browsed
      epson-escpr2
      epson-escpr
      brlaser # brother printers
      gutenprint # general drivers
      gutenprintBin # general but in bin format
      hplip # hp printers
      splix # printers supporting SPL (Samsung Printer Language)
    ];
  };
}
