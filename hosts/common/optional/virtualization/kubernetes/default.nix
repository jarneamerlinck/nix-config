{ config, pkgs, ... }:

{

  environment.systemPackages =  with pkgs; [
    kubernetes-helm
  ];

  environment.sessionVariables = {

    HELM_REPOSITORY_CONFIG = "/etc/helm_repositories.yaml";
  };

  environment.etc."helm_repositories.yaml".text = ''
    apiVersion: ""
    generated: '0001-01-01T00:00:00Z'
    repositories:
      - caFile: ""
        certFile: ""
        insecure_skip_tls_verify: false
        keyFile: ""
        name: "prometheus-community"
        pass_credentials_all: false
        password: ""
        url: "https://prometheus-community.github.io/helm-charts" 
        username: ""

  '';

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
