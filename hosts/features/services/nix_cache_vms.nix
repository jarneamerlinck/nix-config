{ config, pkgs, ... }:

{
  nix.settings = {

    substituters = [
      "https://nix_cache.ko0.net"
    ]
    ++ config.nix.settings.substituters;

    trusted-public-keys = [
      "nix_cache.ko0.net:ggf19YIFJVf0lyfJcP41xxooRehNnraLFtU5tX8MA/Y="
    ]
    ++ config.nix.settings.trusted-public-keys;

  };
}
