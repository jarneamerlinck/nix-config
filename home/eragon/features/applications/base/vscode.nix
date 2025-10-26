{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;
    profiles.default = {
      userSettings = { };
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        yzhang.markdown-all-in-one
        ms-toolsai.jupyter
        njpwerner.autodocstring
      ];
    };
  };
}
