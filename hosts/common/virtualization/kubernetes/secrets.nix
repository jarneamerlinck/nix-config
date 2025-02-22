{ lib, pkgs, ... }:
{

  sops.secrets."sealed-secrets/tls.crt" = {
    sopsFile = ./secrets.yml;
    neededForUsers = false;
  };

  sops.secrets."sealed-secrets/tls.key" = {
    sopsFile = ./secrets.yml;
    neededForUsers = false;
  };

  systemd.services.k8s-sealed-secret-key = {
    description = "Deploy Sealed Secrets TLS Key to Kubernetes";
    after = [ "k3s.service" ];
    requires = [ "k3s.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ kubectl coreutils ];
    script = ''
      export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

      # Delete existing Sealed Secrets TLS secret if it exists
      existing_secret=$(kubectl get secret -n kube-system \
        --selector=sealedsecrets.bitnami.com/sealed-secrets-key=active \
        -o jsonpath='{.items[*].metadata.name}')

      if [ ! -z "$existing_secret" ]; then
        echo "Deleting existing sealed secret: $existing_secret"
        kubectl delete secret -n kube-system "$existing_secret"
      else
        echo "No existing sealed secret found. Proceeding with creation."
      fi


      kubectl apply -f - <<EOF
      apiVersion: v1
      kind: Secret
      metadata:
        name: secret-tls-keys
        namespace: kube-system
        labels:
          sealedsecrets.bitnami.com/sealed-secrets-key: active
      type: kubernetes.io/tls
      data:
        tls.crt: $(base64 -w 0 /run/secrets/sealed-secrets/tls.crt)
        tls.key: $(base64 -w 0 /run/secrets/sealed-secrets/tls.key)
      EOF
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
    };
  };
  #TODO: restart cert manager after 10-15s of boot to refresh the cloudflare api token

  #TODO: make a soft link to the secret instead so k3s will create it

  services.k3s = {
    manifests.secrets = {
      enable = lib.mkDefault true;
      content = [
        # Namespace creation
        {
          apiVersion = "v1";
          kind = "Namespace";
          metadata.name = "kube-system";
        }

        # Helm chart for Prometheus
        {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChart";
          metadata = {
            name =  "sealed-secrets-controller";
            namespace = "kube-system";
          };
          spec = {
            repo = "https://bitnami-labs.github.io/sealed-secrets";
            chart =  "sealed-secrets";
            version = "2.17.1";
            targetNamespace = "kube-system";
            valuesContent = ''
              namespace: kube-system
              skipRecreate: "0"
              metrics:
                serviceMonitor:
                  enabled: true
                  namespace: monitoring
            '';
          };
        }
      ];
    };
  };
}
