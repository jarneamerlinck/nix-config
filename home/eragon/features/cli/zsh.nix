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
      {
        name = "shell-func-config";
        src = lib.cleanSource ./shell_func.sh;
        file = "shell_func.sh";
      }
      ];
    initExtraBeforeCompInit = ''
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';
    initContent = ''
      eval "$(zoxide init zsh)"
      [[ ! -f ${./shell_func.sh} ]] || source ${./shell_func.sh}
    '';
  };
  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };
  home.shellAliases = {
      de="fzf-docker-exec";
      dl="fzf-docker-live-log";
      kn="fzf-kube-namespace";
      kc="fzf-kube-context";
      # dfl="fzf-docker-full-log";
      # dll="fzf-docker-live-log";
      gl="fzf-git-log";
      fssh="fzf-ssh";
    };

}
