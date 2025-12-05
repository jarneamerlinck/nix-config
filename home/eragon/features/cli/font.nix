{ pkgs, lib, ... }:
{

  home.packages = with pkgs; [ dconf ];

  stylix.fonts = {
    serif = {
      package = pkgs.nerd-fonts."fira-mono";
      name = "FiraCode Nerd Font Serif";
    };

    sansSerif = {
      package = pkgs.nerd-fonts."fira-mono";
      name = "FiraCode Nerd Font Sans";
    };

    monospace = {
      package = pkgs.nerd-fonts."fira-mono";
      name = "FiraCode Nerd Font Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
}
