{ pkgs, lib, ... }:
{

  programs.tmux.plugins = lib.mkAfter [
    {
      plugin = pkgs.tmuxPlugins.continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-boot 'on'
        set -g @continuum-save-interval '10'
      '';
    }
  ];
}

