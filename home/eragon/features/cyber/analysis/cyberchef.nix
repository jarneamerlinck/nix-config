{ pkgs, ... }: {
  home.packages = with pkgs; [
    cyberchef
  ];
  xdg.desktopEntries = {
    cyberchef = {
      name = "CyberChef";
      genericName = "The Cyber Swiss Army Knife";
      comment = "CyberChef is a simple, intuitive web app for carrying out all manner of 'cyber' operations within a web browser.";
      exec = "${pkgs.firefox}/bin/firefox file://${pkgs.cyberchef}/share/cyberchef/index.html";
      icon = "cyberchef"; # TODO add icon
      type = "Application";
      terminal = false;
    };
  };
}

