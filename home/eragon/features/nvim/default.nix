{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    ripgrep
    xclip
    luarocks
    go
    shellcheck
    nodejs

  ];
  programs.neovim.extraConfig = ''
      mkdir -p ~/.config
      git clone https://github.com/jarneamerlinck/kickstart.nvim ~/.config/nvim
    '';
}
