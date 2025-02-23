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
              api-token= "AgCy6BLfyfw3bvnqZW1ELC2WFoJAQEKEJ+WjcYC5P3ryVD8z8OETjVe4FoNXVR2u0fzTAh6MePEmItFmZtk4O1LJz3c6Rx8t0VOOQUL5qgC3F7EqvueTi/6CzqkkSgXqcU5Km3yKy/yYgStX/TrSSBKbC6SfSYkAStOQK6KIyzJP2UM2G7evQN27ReWx5FwgA9DQ8cVnWqqsakt/vVKw+/toCGi8U8Wf0aSmqPJNbAOJRDuPq+ObJZmdFU7CVIWfsTMkskPoqSDjgj6EjvZf4R8UA6p/xmUXFOiFIQWjFzfOZI3InOJa+9tYiJVkuZTVjQFyYo+EFqJDNFw8MHphwrZpsZhV6p+YaWMrov3y6W0/EWklC53J+IGmIXqiRAA2AwabrlEpiMRtRmRWEMOM8FfE5QWAgRlqE7Th2xdD74K12FrL4snOZ6rmCfEkgd6phBYIEP19MC/W2+Lf/pbpx0tHmvaSgGlM2YAJvbydKgOMOZNM334a3liQe+MjuWC8hHzwHlX0ETzNctAL3lWl38i+FlpT3pe4DSTMXFiFpR+dxGADa5t06XWmNwN0CLdHfEcYyIAbXSoTtLmo4mTQbWdeixECyB4pY1SxFiSMT5gHy9JxSI+dKpla0CnlOCAcbNPByzb+hi2zYcp+qhU7ibSsK8jEW59Zim9QmEMtDVFBc0GSF7Umk5LfiKoSOLSEmUil+UQl81vkOEYAdMOOpVtFVeUT2nI5bJ2qysQ3q+/Vp8OPitosTAzw";
            };
          };
        }

      ];
    };
  };
}

