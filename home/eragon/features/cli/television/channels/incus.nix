{ pkgs, config, ... }:
{
  home = {
    shellAliases = {
      ic = "tv incus";
    };
  };

  programs.television.channels.incus =
    let
      incus = "${pkgs.incus}/bin/incus";
    in
    {
      metadata = {
        name = "incus";
        description = "Browse Incus containers";
        requirements = [ "incus" ];
      };

      source = {
        # List container names only
        command = "${incus} list --format csv -c n";
        no_sort = true;
        frecency = false;
      };

      keybindings = {
        ctrl-s = "actions:start";
        ctrl-k = "actions:stop";
        ctrl-R = "actions:resume";
        ctrl-r = "actions:restart";
        ctrl-e = "actions:exec";
        ctrl-p = "actions:pause";
      };

      actions = {
        start = {
          description = "Start the selected container";
          command = "${incus} start '{}'";
          mode = "fork";
        };
        stop = {
          description = "Stop the selected container";
          command = "${incus} stop '{}'";
          mode = "fork";
        };
        restart = {
          description = "Restart the selected container";
          command = "${incus} restart '{}'";
          mode = "fork";
        };
        pause = {
          description = "Pause the selected container";
          command = "${incus} pause '{}'";
          mode = "fork";
        };
        resume = {
          description = "Resume the selected container";
          command = "${incus} resume '{}'";
          mode = "fork";
        };
        exec = {
          description = "Enter container shell";
          command = "${incus} exec '{}' -- bash";
          mode = "execute";
        };
      };
    };
}
