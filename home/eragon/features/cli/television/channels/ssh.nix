{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      bat
      fd
      zoxide
    ];
  };
  programs.television.channels."ssh-hosts" =
    # let
    #   zoxide = "${config.programs.zoxide.package}/bin/zoxide";
    # in
    {
      metadata = {
        name = "ssh-hosts";
        description = "A channel to select hosts from your SSH config";
        requirements = [
          "zoxide"
          "grep"
          "tr"
          "cut"
          "awk"
        ];
      };

      source = {
        command = "cat $HOME/.ssh/config 2>/dev/null | grep -E '^Host(name)? ' | tr -s ' ' | cut -d' ' -f2- | tr ' ' '\n' | grep -v '^$'";
        no_sort = false;
        frecency = true;
      };
      preview = {
        command = "cat $HOME/.ssh/config 2>/dev/null | awk '/^Host / { found=0 } /^Host (.*[[:space:]])?'{}'([[:space:]].*)?$/ { found=1 } found'";
      };

      keybindings = {
        enter = "actions:connect";
        ctrl-p = "actions:ping";
      };
      actions = {
        connect = {
          description = "SSH into the selected host";
          command = "ssh '{}'";
          mode = "execute";
        };
        ping = {
          description = "Ping to the selected host";
          command = "echo ping '{}' && ping $(ssh -G $(echo '{}' | awk '{print $1}') | awk '/^hostname / {print $2}')";
          mode = "execute";
        };

      };
    };

}
