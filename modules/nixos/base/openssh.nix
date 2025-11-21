{
  lib,
  config,
  outputs,
  ...
}:
let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  knownHosts = builtins.mapAttrs (host: config: {
    extraHostNames = [ "${host}.ko0.net" ];
    publicKeyFile = ../../../hosts/${host}/ssh_host_ed25519_key.pub;

  }) hosts;
in
{

  options = {

    base.openssh = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the openssh base module";
          };

          persistance = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable persistance for SSH host keys";
          };

          passwordless_sudo = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable passwordless sudo via SSH key-based login";
          };
        };
      };

      default = { };
    };
  };
  config = lib.mkIf config.base."openssh".enable {

    services.openssh = {
      enable = true;
      settings = {
        # Harden
        PasswordAuthentication = false;
        PermitRootLogin = "no";

        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
        # Let WAYLAND_DISPLAY be forwarded
        AcceptEnv = "WAYLAND_DISPLAY";
        X11Forwarding = true;
      };

      hostKeys = [
        {
          path = "${
            lib.optionalString config.base."openssh".persistance "/persist"
          }/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    programs.ssh = {
      setXAuthLocation = true;
      # Each hosts public key

      knownHosts = knownHosts;
    };

    # Passwordless sudo when SSH'ing with keys
    security.pam.sshAgentAuth.enable = config.base."openssh".passwordless_sudo;
  };
}
