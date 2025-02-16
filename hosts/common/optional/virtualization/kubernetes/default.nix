{ config, pkgs, ... }:

{

  environment.systemPackages =  with pkgs; [
    kubernetes-helm
  ];

  # environment.sessionVariables = {
  #
  #   HELM_REPOSITORY_CONFIG = "/etc/helm/.helm/repository.yaml";
  # };

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

        # Helm chart for Prometheus
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "prometheus-stack";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://prometheus-community.github.io/helm-charts";
            chart =  "kube-prometheus-stack";
            version = "69.2.0";
            targetNamespace = "monitoring";
            valuesContent = ''
              grafana:
                enabled: false
                namespaceOverride: monitoring
              namespaceOverride: monitoring
              kube-state-metrics.namespaceOverride: monitoring
              prometheus-node-exporter.namespaceOverride: monitoring
            '';
          };
        }
      ];
    };
  };
}
