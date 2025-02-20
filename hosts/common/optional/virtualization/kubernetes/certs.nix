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
              api-token= "AgCROzYxASY4rKpZFBU/frqSLuPOnY2G3JKldfT739hBaeFTglyyY5czFw4k0Ob484Hvo5n0FE9mUMKoze3CTLiaTliU//xcUvBnlsMKPiR4+tah4v3NP4NJM7Rvej6IODfyRNU4jbqjVaU6WkcYuo8kydrvrDSS6nNu0OxoTHEkKrAuM+qbarX30zgfP0nSbh9uF6OoBCFL7zfcROpoAPThu1qNVaA05VHLZgMAyCfvy87a7DuQC0NPFUJonB4L+DhwtClb/dZvIZJTfLPae4E+/1nvR8Zp0mczc5dCcnJcSgV2WnnYTSP8JXAz1iL7cR8myN7iy77tbN+bjsrXctxQ+TxJ2tsitvwOaLal7QQb8oadaAo2imtPKfasXzjlxSuhkLEpPRcIrW/G82j0wwg23J3MsCrOrUVEnD88SfDpo9EQBGipLzYATxFagn6YSbzhmBt+MFdeK7UaozJuokuRh7xKGkf7j7TqCvZFLnH9OjUWgo0TKTIoKUe/PxZ9yixZBSnU2mXIXQNdvI4MFGYt/EFQCjW/Grg4wLOoaioSukX8ZPMxhgaDh6SssZd5yzlbpCe/eqZ8b5l5/YidNbOi/l04e/e6+3n3DZxYvGmiIXkg84U8B0pECARyh7ZID7ftssA817rAoTULEhayivbGBcjpYKdhcIb986cSOPJLrJiEyFiDmqh4LHJv71FGbPCAl5Xninahpb3SAG3mow9ECR+NEth+ZtyXKaNfghgmbySvo88yw4c5";
            };
          };
        }

      ];
    };
  };
}

