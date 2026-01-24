{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gh
    lazygit
    pre-commit
  ];

  home.shellAliases = {
    d = "docker";
    lg = "lazygit";
  };
  programs.git = {
    enable = true;
    settings = {

      alias = {
        graph = "log --decorate --oneline --graph";
      };
      user = {
        name = "jarneamerlinck";
        email = "jarneamerlinck@pm.me";
      };

      init.defaultBranch = "main";

      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Reuse merge conflict fixes when rebasing
      rerere.enabled = true;
      pull.rebase = true;

    };
    lfs.enable = true;
    ignores = [
      ".direnv"
      "result"
    ];
  };
}
