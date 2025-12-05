{ lib, ... }:
{
  home.file.".config/hexecute/gestures.json".source = lib.cleanSource ./gestures.json;

}
