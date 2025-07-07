{ pkgs, ... }: {
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
  home = {
    shellAliases = {
      v="nvim";
      rebuild ="cd ~/nix-config &&  ./deploy.sh";
      rebuildf="cd ~/nix-config && git stash &&  git pull -f && ./deploy.sh";
      rebuildl="cd ~/nix-config && ./deploy.sh";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      comma # Install and run programs by sticking a , before them

      # Monitor tools
      btop
      htop
      neofetch

      # ncdu # TUI disk usage
      ripgrep # Better grep
      fd # Better find
      wget

      dig

      zoxide
      fzf

      nil # Nix LSP
      nixfmt-rfc-style # Nix formatter
      # nixfmt-classic # Prev formater
      nvd # Differ
      nix-output-monitor

      # terminals
      kitty

      ffmpeg


    ];
  };
}
