{ config, pkgs, ... }:
{
  nix.settings = {
    substituters = [
      "https://nix_cache.ko0.net/"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "nix_cache.ko0.net:ggf19YIFJVf0lyfJcP41xxooRehNnraLFtU5tX8MA/Y="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

  };
}
