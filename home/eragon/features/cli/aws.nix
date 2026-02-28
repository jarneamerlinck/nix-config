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
}
