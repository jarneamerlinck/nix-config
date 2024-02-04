{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    ripgrep
    xclip
    lua
    luarocks
    go
    shellcheck
    nodejs
    gcc
    clangStdenv
    python39
    fzf
    zoxide

    vimPlugins.telescope-fzf-native-nvim
    lazygit

  ];
  programs.neovim.extraConfig = ''
      mkdir -p ~/.config
      git clone https://github.com/jarneamerlinck/kickstart.nvim ~/.config/nvim
    '';
}
