{ lib, ... }:
{

  services.k3s = {
    manifests."cert-manager" = {
      enable = lib.mkDefault true;
      content = [

        # Namespace creation
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata.name = "certs";
        }
        # Helm chart for Cert manager
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "cert-manager";
            namespace = "certs";
          };
          spec = {
            repo = "https://charts.jetstack.io";
            chart =  "cert-manager";
            version = "v1.17.1";
            targetNamespace = "certs";
            valuesContent = ''
              crds:
                enabled: true
            '';
          };
        }
      ];
    };
  };
}
