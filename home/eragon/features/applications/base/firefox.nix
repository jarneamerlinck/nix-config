{ config, pkgs, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  home.packages = with pkgs; [
    speechd
  ];
  stylix.targets.firefox.profileNames = [
    "base_profile"
  ];
  stylix.targets.firefox.colorTheme.enable = true;
  programs = {
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          # ---- Policies ----
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
          SearchBar = "unified"; # alternative: "separate"
          SearchEngine = {
            Default = "DuckDuckGo";
            PreventInstalls = true;
          };

          # ---- PREFERENCES ----
          # Set preferences shared by all profiles.
          Preferences = {
            "browser.contentblocking.category" = {
              Value = "strict";
              Status = "locked";
            };
            "extensions.pocket.enabled" = lock-false;
            "extensions.screenshots.disabled" = lock-true;
            # add global preferences here...
          };
        };
      };

      # ---- PROFILES ----
      # Switch profiles via about:profiles page.
      # For options that are available in Home-Manager see
      # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
      profiles = {
        base_profile = {
          # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
          id = 2; # 0 is the default profile; see also option "isDefault"
          name = "base_profile"; # name as listed in about:profiles
          isDefault = true; # can be omitted; true if profile ID is 0
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              darkreader
              bitwarden
              # user-agent-switcher
            ];
          };
          settings = {
            # specify profile-specific preferences here; check about:config for options
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.startup.homepage" = "https://github.com/jarneamerlinck/nix-config";
            # add preferences for profile_0 here...
          };
        };
        # add profiles here...
      };
    };
  };
}
