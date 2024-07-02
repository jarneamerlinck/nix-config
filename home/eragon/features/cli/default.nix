{ pkgs, ... }: {
  imports = [
    # ./bash.nix
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
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them

    # Monitor tools
    btop
    htop
    neofetch

    # ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    wget

    nil # Nix LSP
    nixfmt # Nix formatter
    nvd # Differ
    nix-output-monitor

    # terminals
    kitty


  ];
}
