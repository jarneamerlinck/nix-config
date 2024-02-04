{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    initExtraBeforeCompInit = ''
    eval "$(zoxide init zsh)"
    '';
  };
  home = {
    shellAliases = {
      v="nvim";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
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
  };
  programs.neovim.extraConfig = ''
      mkdir -p ~/.config
      touch ~/.demo_was_this_here
      git clone https://github.com/jarneamerlinck/kickstart.nvim ~/.config/nvim

    '';
}
