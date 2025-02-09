{ config, pkgs, ... }:

{
  services.k3s = {

    manifests.prometheus = {
      enable = true;
      content = [
        # Namespace creation
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata.name = "monitoring";
        }

        # Hem repo
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmRepository";
          metadata = {
            namespace = "kube-system";
          };
          spec.url = "https://prometheus-community.github.io/helm-charts";
        }
        # Helm chart for Prometheus
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "prometheus-stack";
            namespace = "kube-system";
          };
          spec = {
            chart =  "prometheus-community/kube-prometheus-stack";
            version = "69.2.0";
            targetNamespace = "monitoring";
            valuesContent = ''
              grafana:
                enabled: false
              namespaceOverride: monitoring
            '';
          };
        }
      ];
    };
  };
}
