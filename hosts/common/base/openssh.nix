{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasOptinPersistence = false;
  # hasOptinPersistence = config.environment.persistence ? "/persist";
  knownHosts = builtins.mapAttrs (host: config: {
    extraHostNames = [ "${host}.ko0.net" ];
    publicKeyFile = ../../${host}/ssh_host_ed25519_key.pub;  # Adjust if public key file paths are specific to each host
  }) hosts;
in
{
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
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
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
  security.pam.sshAgentAuth.enable = true;
}
