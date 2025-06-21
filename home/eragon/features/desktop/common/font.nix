{ pkgs, lib,  ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font Mono";
      package = [  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}

