{ pkgs, lib,  ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts."fira-mono";
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}

