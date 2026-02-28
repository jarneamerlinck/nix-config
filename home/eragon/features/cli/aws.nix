{ ... }:
{
  programs.awscli = {
    enable = true;
    settings = {
      default = {
        region = "garage";
        endpoint_url = "https://storage.ko0.net";
        output = "json";
      };
    };
  };
  home.shellAliases = {
    s3 = "aws s3";
  };

}
