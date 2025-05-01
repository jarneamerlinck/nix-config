{ lib, ... }:
{

  sops.secrets."kubernetes/cloudflare-api-token.yaml" = {
    sopsFile = ./secrets.yml;
    neededForUsers = false;
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/rancher/k3s/server/manifests/cloudflare-api-token.yaml - - - - /run/secrets/kubernetes/cloudflare-api-token.yaml"
  ];
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
                ssl:
                  certificates:
                    - name: haproxy-cert
                      secret:
                        name: haproxy-cert
                        namespace: certs
            '';
          };
        }

      ];
    };
    manifests."cert-manager" = {
      enable = lib.mkDefault true;
      content = [

        # Helm chart for Cert manager
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "cert-manager";
            namespace = "certs";
          };
          spec = {
            repo = "https://charts.jetstack.io";
            chart =  "cert-manager";
            version = "v1.17.1";
            targetNamespace = "certs";
            valuesContent = ''
              crds:
                enabled: true
            '';
          };
        }

        # Fetch secrets
        {
          apiVersion = "cert-manager.io/v1";
          kind = "ClusterIssuer";

          metadata = {
            name =  "letsencrypt-cloudflare";
            namespace = "certs";
          };
          spec = {
            acme= {
              email = "jarneamerlinck@pm.me";
              server = "https://acme-v02.api.letsencrypt.org/directory";
              privateKeySecretRef.name = "letsencrypt-cloudflare";
              solvers= [
                {
                  dns01 = {
                    cloudflare.apiTokenSecretRef = {
                      name = "cloudflare-api-token-secret";
                      key =  "api-token";
                    };
                  };
                }
              ];
            };
          };
        }

        # Make hayproxy use cert-manager certs
        {
          apiVersion = "cert-manager.io/v1";
          kind = "Certificate";

          metadata = {
            name =  "haproxy-tls";
            namespace = "certs";
          };
          spec = {
            secretName = "letsencrypt-cloudflare";
            issuerRef = {
              name =  "letsencrypt-cloudflare";
              kind = "ClusterIssuer";
            };
            dnsNames = [
              "*.ko0.net"
              "*.85311442.xyz"
            ];
          };
        }

      ];
    };
  };
}

