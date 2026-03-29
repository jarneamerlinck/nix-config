{ pkgs, config, ... }:
{
  home = {
    shellAliases = {
      ie = "tv incus";
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
        enter = "actions:shell";
      };

      actions = {
        shell = {
          description = "Enter container shell";
          command = "${incus} exec '{}' -- bash";
          mode = "execute";
        };
      };
    };
}
