{
  config,
  inputs,
  ...
}:
{

  sops.secrets."hermes/env" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = false;
  };
  imports = [ inputs.hermes-agent.nixosModules.default ];
  services.hermes-agent = {
    enable = true;
    settings = {
      model = {
        default = "gpt-oss:20b";
      };
    };

    environmentFiles = [ config.sops.secrets."hermes/env".path ];
    addToSystemPackages = true;
    container.enable = true;
    container.hostUsers = [ "eragon" ];
  };
}
