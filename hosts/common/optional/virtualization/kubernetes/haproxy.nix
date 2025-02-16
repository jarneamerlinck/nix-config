{ lib, ... }:
{

  services.k3s = {
    manifests.haproxy = {
      enable = lib.mkDefault true;
      content = [
        # Helm chart for Haproxy
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "harpoxy-ingress";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://haproxytech.github.io/helm-charts";
            chart =  "kubernetes-ingress";
            version = "1.44.0";
            targetNamespace = "kube-system";
            valuesContent = ''
            '';
          };
        }
      ];
    };
  };
}
