{ ... }:
{
  nix.settings = {
    substituters = [
      "https://nix.cache.ko0.net/"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "nix.cache.ko0.net:GtHtHec2fVedkzmQyaBu9/Ug7qWGGm4WA3joz3beTdc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

  };
}
