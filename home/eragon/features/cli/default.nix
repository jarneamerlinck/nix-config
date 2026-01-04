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
      rebuild = "cd $NH_FLAKE &&  ./deploy.sh";
      rebuildf = "cd $NH_FLAKE && git stash &&  git pull -f && ./deploy.sh";
      rebuildl = "cd $NH_FLAKE && ./deploy.sh";
      debug = ''
        nix-inspect --expr "builtins.getFlake \"$(pwd)\""
      '';
      fldebug = "cd $NH_FLAKE && debug";
      wg-down = "sudo systemctl stop wireguard-wg0.service";
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
      nix-inspect

      feh
      ffmpeg

    ];
  };
}
