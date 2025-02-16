{ lib, ... }:
{

  services.k3s = {
    manifests.haproxy = {
      enable = lib.mkDefault true;
      content = [

        # Namespace creation
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata.name = "certs";
        }
        # Helm chart for Haproxy
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "harpoxy-ingress";
            namespace = "certs";
          };
          spec = {
            repo = "https://haproxytech.github.io/helm-charts";
            chart =  "kubernetes-ingress";
            version = "1.44.0";
            targetNamespace = "certs";
            valuesContent = ''
              controller:
                service:
                  type: LoadBalancer
                containerPort:
                  http: 80
                  https: 443
                  stats: 1024
                allowPrivilegedPorts: true
            '';
          };
        }
      ];
    };
  };
}
