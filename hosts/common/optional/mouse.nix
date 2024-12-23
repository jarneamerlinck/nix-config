{ pkgs, lib, config, inputs, ... }:
{
  # environment.systemPackages = with pkgs; [
  #   piper
  #   solaar
  # ];
  services.ratbagd.enable = true;
}
