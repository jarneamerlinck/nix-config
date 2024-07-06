{config, inputs, lib, ... }:

{
  disko.devices.disk.example = {
    type = "disk";
    device = "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512MiB";
          type = "EF00";
          priority = 1;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          priority = 2;
          fs-type = "ext4";
        };
      };
    };
  };



}
