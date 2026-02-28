{ lib, ... }:
{
  programs.awscli = {
    enable = true;
    settings = {
      default = {
        region = "garage";
        output = "json";
      };
    };
  };
  home.shellAliases = {
    s3 = "aws s3";
  };

}
