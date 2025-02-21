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
            secretName = "haproxy-tls-secret";
            issuerRef = {
              name =  "letsencrypt-cloudflare";
              kind = "ClusterIssuer";
            };
            dnsNames = [
              "*.ko0.net"
            ];
          };
        }

        # Add cloudflare cert with sealed secrets
        {
          apiVersion = "bitnami.com/v1alpha1";
          kind = "SealedSecret";

          metadata = {
            name =  "cloudflare-api-token-secret";
            namespace = "certs";
          };
          spec = {
            template = {
              metadata = {
                name =  "cloudflare-api-token-secret";
                namespace = "certs";
              };
              type = "Opaque";
            };
            encryptedData = {
              api-token= "AgDOxmJr9LBRXryQChs47V3K3kINZysq7zn/AtHjMf6G5YyCc/fLJqZ9vx7byqhJTB35aDiL43qp65CHaV3neR/INDcJqpJWKAJjJupa0kY1MtCbfUggKMBHfUVzmU6ASNJitChrfl41JItOYO3FThPhGASKtur2UokulQ8m3KPg+xuo/25jGgncxeeIKyJNXfMs+PlvZl5eZcpOCuhOFa6kNPPsFMle83gUs7kBNhEH/ynuvGpe5CWYc+bAaGR8UUaUejqO/rrAcaKaVF95C+FvXbIQgMJkDMXlTbVcOCOIDA1f6ZgKMEqhNRKLbQk4wSOnGyuwk6y62N53biJv8RCBH1UfYL13JsC0maASDfo3oiFYk4L61uwX3ZIwy1aAzG0U5Plse3c17doJ+2WX4q8mAHdMCgXk8NjhyxQT+4S2BaGOPeuVH5Lzmwunqg5Z/OcLOwcCOdv/0+ay8G6Mf56mO/al/XD/mVumQK6GZfXo/XKZWLcu7yTIz45kRSZTYuYz82o1QyDAtNwSUGiWLBXJX/cnR0p6TC8mpK5yVVYrdjNlH+Zb1WeMNWXaWCIqfPI7xZ/His99JOP1USdlPrSYjNniltNaxL6rLm5j+eCK/CHRq/+sQoZexwBvM4+YljjwHn4dsfzYAg16ysONvjHdBDA5dvXqY+UjbKsZUY5/bpHoOuEhn78+P2oXlPXIt9CDP1+iJzMY3JVS/WJ8qaeChhsbdPSot/bIXn1lRA5lxBbed3xbNkVl";
            };
          };
        }

      ];
    };
  };
}

