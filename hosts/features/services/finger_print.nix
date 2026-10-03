{ pkgs, lib, ... }:
{
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "net.reactivated.fprint.device.enroll" ||
           action.id == "net.reactivated.fprint.device.verify") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
  security.pam.services.swaylock = {
    fprintAuth = true;
    text = ''
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth sufficient pam_fprintd.so
      auth include login
    '';
  };
}
