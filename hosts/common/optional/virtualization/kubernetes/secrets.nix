{ lib, ... }:
{

  sops.secrets."sealed-secrets/tls.crt" = {
    sopsFile = ./secrets.yml;
    neededForUsers = false;
  };

  sops.secrets."sealed-secrets/tls.key" = {
    sopsFile = ./secrets.yml;
    neededForUsers = false;
  };
  services.k3s = {
    manifests.secrets = {
      enable = lib.mkDefault true;
      content = [
        # Namespace creation
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata.name = "kube-system";
        }

        # Helm chart for Prometheus
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "sealed-secrets";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://bitnami-labs.github.io/sealed-secrets";
            chart =  "sealed-secrets";
            version = "2.17.1";
            targetNamespace = "kube-system";
            valuesContent = ''
              namespace: kube-system
              skipRecreate: "0"
              metrics:
                serviceMonitor:
                  enabled: true
                  namespace: monitoring
            '';
          };
        }
      ];
    };
  };
}
