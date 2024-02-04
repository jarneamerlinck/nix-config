{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    neovim
  ];
  programs.neovim.extraConfig = ''
      mkdir -p ~/.config
      git clone https://github.com/jarneamerlinck/kickstart.nvim ~/.config/nvim
    '';
}
