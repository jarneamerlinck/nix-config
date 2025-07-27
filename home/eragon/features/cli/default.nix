{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./zsh.nix
    ./git.nix
    ./kitty.nix
    ./tmux.nix
    ./fetch.nix
    ./font.nix
    ./ssh.nix
    ./docker.nix
    ./python.nix
  ];

  programs.btop.enable = true;
  programs.htop.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  home = {
    shellAliases = {
      v = "nvim";
      rebuild = "cd ~/nix-config &&  ./deploy.sh";
      rebuildf = "cd ~/nix-config && git stash &&  git pull -f && ./deploy.sh";
      rebuildl = "cd ~/nix-config && ./deploy.sh";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
      # comma # Install and run programs by sticking a , before them

      # ncdu # TUI disk usage
      ripgrep # Better grep
      fd # Better find
      wget

      dig

      nil # Nix LSP
      nixfmt-rfc-style # Nix formatter
      # nixfmt-classic # Prev formater
      nvd # Differ
      nix-output-monitor

      ffmpeg

    ];
  };
}
