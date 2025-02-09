{ config, pkgs, ... }:

{

  systemd.services.add-helm-repo = {
    description = "Add Prometheus Community Helm Repo";
    serviceConfig.ExecStart = "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts";
    serviceConfig.Environment = "DISPLAY=";  # Prevents any DISPLAY (X server) environment variable from being set
    serviceConfig.User = "root";  # Specify which user the service should run as
    serviceConfig.Group = "root";  # Ensure it runs with the appropriate group privileges
    wantedBy = [ "multi-user.target" ];
  };
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
