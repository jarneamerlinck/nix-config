{ pkgs, ... }:
{
  imports = [
    ./channels/zoxide.nix
    ./channels/nix-packages.nix
    ./channels/incus.nix
    ./channels/ssh.nix
    ./channels/docker-containers.nix
  ];

  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };
  home = {
    shellAliases = {
      tvc = "tv channels";
      nix-options = "tv nix-search-tv";
      nshell = "tv nixpkgs";
    };
    packages = with pkgs; [
      bat
      fd
    ];
  };
  programs.television = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      features = {
        preview_panel = {
          enabled = true;
          visible = true;
        };
        remote_control = {
          enabled = true;
          visible = false;
        };
        help_panel = {
          enabled = true;
          visible = false;
        };
        status_bar = {
          enabled = true;
          visible = true;
        };
      };
    };
    # keybindings = {
    #   quit = [
    #     "esc"
    #     "ctrl-c"
    #   ];
    # };
  };

}
