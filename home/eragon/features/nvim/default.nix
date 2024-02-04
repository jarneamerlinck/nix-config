{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    ripgrep
    xclip
    python3-venv
    luarocks
    golang-go
    shellcheck
    nodejs

  ];
  programs.neovim.extraConfig = ''
      mkdir -p ~/.config
      git clone https://github.com/jarneamerlinck/kickstart.nvim ~/.config/nvim
    '';
}
