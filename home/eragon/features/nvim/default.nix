{
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.zsh = {
    initExtraBeforeCompInit = ''
    eval "$(zoxide init zsh)"
    '';

  home.shellAliases = {
    v="nvim";
    z="zoxide";
  };

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
