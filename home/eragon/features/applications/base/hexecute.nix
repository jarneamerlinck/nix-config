{ lib, ... }: {
  home.file.".config/hexecute/gestures.json".text =
    lib.cleanSource ./gestures.json;

}
