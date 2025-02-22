
{
  # on the host the video should be set to "video QXl" and not "video virtio"
  services.qemuGuest.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
