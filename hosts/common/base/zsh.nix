{ pkgs, lib,  ... }: {
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k.zsh;
        file = "p10k.zsh";
      }
      ];
    initExtraBeforeCompInit = ''
    [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';
  };
}
