{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.sops
    pkgs.pre-commit
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.nix = {
    enable = true;

  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  # enterShell = ''
  #   hello         # Run scripts directly
  #   git --version # Use packages
  # '';

  # https://devenv.sh/tasks/
  tasks = {
    "nix-update:flake" = {
      exec = "nix flake update && git reset && git add ./flake.lock && git commit -m 'chore: nix flake update'";
    };
    "nix-update:devenv" = {
      exec = "devenv update && git reset && git add ./devenv.lock && git commit -m 'chore: devenv flake update'";
      # after = [ "nix:flake-update" ];
    };
    "git:precommit" = {
      exec = "pre-commit run --all";
    };
    "git:branch-cleanup-main" = {
      exec = "git branch --merged main   | sed 's/^[* ]*//'   | sort -u   | grep -vE '^(main|stable)$'   | xargs -r git branch -d";
    };

    "git:branch-cleanup-stable" = {
      exec = "git branch --merged stable | grep -vE '^\*|^\s*(stable|main)$' | xargs -r git branch -D";
    };
    "git:remote-branch-cleanup" = {
      exec = "git fetch --prune";
    };

  };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
