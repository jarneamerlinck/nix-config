{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      bat
      fd
      # grep
      # tr
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
        requirements = [ "zoxide" ];
      };

      source = {
        command = "grep -E '^Host(name)? ' $HOME/.ssh/config | tr -s ' ' | cut -d' ' -f2- | tr ' ' '\n' | grep -v '^$'";
        preview = "awk '/^Host / { found=0 } /^Host (.*[[:space:]])?'{}'([[:space:]].*)?$/ { found=1 } found' $HOME/.ssh/config";
        no_sort = true;
        frecency = false;
      };

      keybindings = {
        enter = "actions:connect";
      };
      actions = {
        connect = {
          description = "SSH into the selected host";
          command = "ssh '{}' {args}";
          mode = "execute";
        };
      };
    };

}
