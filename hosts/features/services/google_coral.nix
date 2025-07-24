{ pkgs, lib, ... }:

{
  hardware.coral.usb.enable = true;

  environment.systemPackages = with pkgs; [
    libedgetpu
    edgetpu-compiler
  ];
}
