{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  # pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;
  # gitHost = hosts."alcyone".config.networking.hostName;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasOptinPersistence = false;
  # hasOptinPersistence = config.environment.persistence ? "/persist";
  knownHosts = builtins.mapAttrs (name: config: {
    extraHostNames = [ "${name}.mydomain.com" ];
    publicKeyFile = ../../../home/eragon/ssh.pub;  # Adjust if public key file paths are specific to each host
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
    # knownHosts = lib.genAttrs hosts (hostname: {
    #   publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      # extraHostNames =
      #   [
      #     "${hostname}.m7.rs"
      #   ]
      #   ++
      #   # Alias for localhost if it's the same host
      #   (lib.optional (hostname == config.networking.hostName) "localhost")
      #   # Alias to m7.rs and git.m7.rs if it's alcyone
      #   ++ (lib.optionals (hostname == "alcyone") [
      #     "m7.rs"
      #     "git.m7.rs"
      #   ]);
      # extraHostNames =
      #   [
      #     "${hostname}.ko0.net"
      #   ];
        # ++
        # # Alias for localhost if it's the same host
        # (lib.optional (hostname == config.networking.hostName) "localhost")
        # Alias to m7.rs and git.m7.rs if it's alcyone
        # ++ (lib.optionals (hostname == "alcyone") [
        #   "m7.rs"
        #   "git.m7.rs"
        # ])

    # });
  };
  # programs.ssh = {
  #   # Each hosts public key
  #   knownHosts = builtins.mapAttrs
  #     (name: _: {
  #       # publicKeyFile = pubKey name;
  #       extraHostNames =
  #         (lib.optional (name == hostName) "localhost") ++ # Alias for localhost if it's the same host
  #     })
  #     hosts;
  # };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth.enable = true;
}
