{ pkgs, ... }: {
  home.packages = with pkgs; [ kdePackages.kdenlive obs-studio glaxnimate ];
}
