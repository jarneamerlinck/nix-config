{ pkgs, config, ... }:
{
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };
  home = {
    shellAliases = {
      tvc = "tv channels";
    };
    packages = with pkgs; [
      bat
      fd
    ];
  };
  programs.television.channels.zoxide =
    let
      zoxide = "${config.programs.zoxide.package}/bin/zoxide";
    in
    {
      metadata = {
        name = "zoxide";
        description = "Browse zoxide directory history";
        requirements = [ "zoxide" ];
      };

      source = {
        command = "${zoxide} query -l";
        no_sort = true;
        frecency = false;
      };

      keybindings = {
        enter = "actions:cd";
      };
      actions = {
        cd = {
          description = "Change to the selected directory";
          command = "cd '{}' && $SHELL";
          mode = "execute";
        };
      };
    };

}
