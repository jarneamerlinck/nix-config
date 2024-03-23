{ outputs, lib, ... }:
{
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    aliases = {
      graph = "log --decorate --oneline --graph";
    };
    userName = "jarneamerlinck";
    userEmail = "jarneamerlinck@pm.me";
    extraConfig = {
      init.defaultBranch = "main";

      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Reuse merge conflict fixes when rebasing
      rerere.enabled = true;
    };
    lfs.enable = true;
    ignores = [ ".direnv" "result" ];
  };
}
