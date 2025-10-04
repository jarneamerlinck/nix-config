{
  outputs,
  lib,
  config,
  ...
}:
let
  nixosConfigs = builtins.attrNames outputs.nixosConfigurations;
  # homeConfigs = map (n: lib.last (lib.splitString "@" n)) (builtins.attrNames config.homeConfigurations);
  homeConfigs = [
    "testing"
    "vm1"
    "atlas"
    "banshee"
    "ash"
  ];
  hostnames = lib.unique (homeConfigs ++ nixosConfigs);
in
{
  # Persisting known_hosts with impermance is wonky, as SSH sometimes
  # overwrites it. My workaround is to make a known_hosts.d directory instead,
  # which is persisted.
  # home.persistence = {
  #   "/persist/${config.home.homeDirectory}".directories = [
  #     ".ssh/known_hosts.d"
  #   ];
  # };

  programs.ssh = {
    enable = true;
    # See above
    # userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts.d/hosts";
    matchBlocks = {
      net = {
        host = lib.concatStringsSep " " (
          lib.flatten (
            map (host: [
              "${host}.ko0.net"
            ]) hostnames
          )
        );
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
        setEnv.WAYLAND_DISPLAY = "wayland-waypipe";
        extraOptions.StreamLocalBindUnlink = "yes";
      };
    };
  };

  # Compatibility with programs that don't respect SSH configurations (e.g. jujutsu's libssh2)
  # systemd.user.tmpfiles.rules = [
  #   "L ${config.home.homeDirectory}/.ssh/known_hosts - - - - ${config.programs.ssh.userKnownHostsFile}"
  # ];
}
