{ pkgs, config, ... }:
{
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };
  programs.television = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    channels = {
      zoxide =
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

          # preview.command = "${
          #   escapeShellArgs (
          #     [ "${getExe package}" ]
          #     ++ extraOptions
          #     ++ [
          #       "--color=${colors}"
          #       "--icons=${icons}"
          #     ]
          #   )
          # } '{}'";

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
    };
  };

}
