{ config, pkgs, ... }:

{

  environment.systemPackages =  with pkgs; [
    kubernetes-helm
  ];


  systemd.services.add-helm-repo = {
    description = "Add Prometheus Community Helm Repo";
    serviceConfig.ExecStart = "${pkgs.kubernetes-helm}/bin/helm repo add prometheus-community https://prometheus-community.github.io/helm-charts";
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
