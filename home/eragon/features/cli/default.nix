{ pkgs, ... }: {
  imports = [
    # ./bash.nix
    # ./bat.nix
    # ./direnv.nix
    ./zsh.nix
    # ./gh.nix
    # ./git.nix
    # ./gpg.nix
    # ./jujutsu.nix
    # ./lyrics.nix
    # ./nix-index.nix
    # ./pfetch.nix
    # ./ranger.nix
    # ./screen.nix
    # ./shellcolor.nix
    ./ssh.nix
    # ./starship.nix
    # ./xpo.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    # Monitor tools
    btop
    htop
    neofetch

    # ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find

    nil # Nix LSP
    nixfmt # Nix formatter
    nvd # Differ
    nix-output-monitor

    # terminals
    kitty


  ];
}
