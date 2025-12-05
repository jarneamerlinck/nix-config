{ lib, pkgs, ... }:
{
  specialisation = {
    light.configuration = {
      stylix.polarity = lib.mkForce "light";
    };

    dark.configuration = {
      stylix.polarity = lib.mkForce "dark";
    };
  };

}
