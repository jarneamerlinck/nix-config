{ lib, ... }:
{

  services.k3s = {
    manifests."cert-manager" = {
      enable = lib.mkDefault true;
      content = [
        # Helm chart for Cert manager
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "cert-manager";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://charts.jetstack.io";
            chart =  "cert-manager";
            version = "v1.17.1";
            targetNamespace = "kube-system";
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
