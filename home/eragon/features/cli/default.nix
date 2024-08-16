{ pkgs, ... }: {
  imports = [
    # ./bat.nix
    ./direnv.nix
    ./zsh.nix
    ./git.nix
    # ./gpg.nix
    ./kitty.nix
    ./tmux.nix
    # ./lyrics.nix
    ./fetch.nix
    # ./ranger.nix
    # ./screen.nix
    # ./shellcolor.nix
    ./ssh.nix
    ./docker.nix
    # ./starship.nix
    # ./xpo.nix
  ];
  home = {
    shellAliases = {
      v="nvim";
      rebuild="cd ~/nix-config && git stash &&  git pull && ./deploy.sh";
      rebuildf="cd ~/nix-config && git stash &&  git pull -f && ./deploy.sh";

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

      zoxide
      fzf

      nil # Nix LSP
      nixfmt-rfc-style # Nix formatter
      # nixfmt-classic # Prev formater
      nvd # Differ
      nix-output-monitor

      # terminals
      kitty


    ];
  };
}
