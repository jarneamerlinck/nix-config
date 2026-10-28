{ config, lib, ... }:

{
  options.networkAliases = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Shared Docker network aliases.";
  };
}
