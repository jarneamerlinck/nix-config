{ lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    plugins = [
      {
        name = "shell-func-config";
        src = lib.cleanSource ./shell_func.sh;
        file = "shell_func.sh";
      }
    ];
    initContent = ''

      eval "$(zoxide init zsh)"
      [[ ! -f ${./shell_func.sh} ]] || source ${./shell_func.sh}
    '';
  };
  programs.starship = {
    enable = true;
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  home.shellAliases = {
    de = "fzf-docker-exec";
    dl = "fzf-docker-live-log";
    kn = "fzf-kube-namespace";
    kc = "fzf-kube-context";
    # dfl="fzf-docker-full-log";
    # dll="fzf-docker-live-log";
    gl = "fzf-git-log";
    fssh = "fzf-ssh";
    hms = "fzf-hm-specialisation";
    l = "eza -l";
    ll = "eza -ahl";
  };

}
