{ pkgs, lib,  ... }: {

  home.packages = with pkgs; [
    dconf
  ];
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

