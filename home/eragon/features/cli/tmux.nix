{ outputs, lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      tmux
    ];
    shellAliases = {
      t="tmux";
    };
  };
  # programs.tmux = {
  #   enable = true;
  #   shell = "${pkgs.bash}/bin/bash";
  #   clock24 = true;
  #   terminal="screen-256color";
  #   # plugins = with pkgs; [
  #   #   tmuxPlugins.cpu
  #   #   {
  #   #     plugin = tmuxPlugins.resurrect;
  #   #     extraConfig = "set -g @resurrect-strategy-nvim 'session'";
  #   #   }
  #   #   {
  #   #     plugin = tmuxPlugins.continuum;
  #   #     extraConfig = ''
  #   #       set -g @continuum-restore 'on'
  #   #       set -g @continuum-save-interval '60' # minutes
  #   #     '';
  #   #   }
  #   # ];
  #
  #
  # };


}
