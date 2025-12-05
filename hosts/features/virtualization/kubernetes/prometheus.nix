{ lib, config, ... }:
{

  services.k3s = {
    manifests.prometheus = {
      enable = lib.mkDefault true;
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
            name = "prometheus-stack";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://prometheus-community.github.io/helm-charts";
            chart = "kube-prometheus-stack";
            version = "69.2.0";
            targetNamespace = "monitoring";
            valuesContent = ''
              grafana:
                enabled: true
                namespaceOverride: monitoring
                ingress:
                  enabled: false
                  hosts: [${config.networking.hostName}.ko0.net]
                  annotations:
                    cert-manager.io/cluster-issuer: "letsencrypt-cloudflare"
                  tls:
                    - hosts:
                        - '*.ko0.net'
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
