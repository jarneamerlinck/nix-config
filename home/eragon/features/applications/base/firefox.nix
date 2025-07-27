{ config, pkgs, ... }:

let
  chat_uri = "https://chat.ko0.net";
  chat_options = "?model=firefox-side-bar&temporary-chat=false&tools=jina_web_scrape";
in
{
  home.packages = with pkgs; [
    speechd
  ];
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
          };
        };
      };

      # ---- PROFILES ----
      # Switch profiles via about:profiles page.
      # For options that are available in Home-Manager see
      # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
      profiles = {
        base_profile = {
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
            # Disable Pocket
            "extensions.pocket.enabled" = false;

            # Disable Firefox Account / Sync
            "identity.fxaccounts.enabled" = false;
            "services.sync.engine.prefs" = false;
            "services.sync.engine.passwords" = false;
            "services.sync.engine.history" = false;
            "services.sync.engine.tabs" = false;
            "services.sync.engine.bookmarks" = false;
            "services.sync.engine.addons" = false;
            "services.sync.engine.creditcards" = false;
            "services.sync.engine.addresses" = false;


            # Disable password saving
            "signon.rememberSignons" = false;  # Disable saving passwords

            # Disable autofill
            "browser.formfill.enable" = false;  # Disable form autofill

            # Disable saving payment methods
            "payments.enabled" = false;  # Disable saving credit card/payment methods

            # ML integration


            ## Enable Firefox ML chat features
            "browser.ml.chat.enabled" = true;

            ## Show localhost in ML chat features
            "browser.ml.chat.hideLocalhost" = false;
            "browser.ml.chat.provider" = "${chat_uri}/${chat_options}";

            # Others
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.startup.homepage" = "https://github.com/jarneamerlinck/nix-config";
          };
          search = {
            default = "searxng"; # duckduckgo
            force = true; # This locks the default engine
            engines = {

              "searxng" = {
                urls = [
                  {
                    template = "https://search.ko0.net/?q={searchTerms}";
                  }
                ];
                icon = "https://search.ko0.net/favicon.ico";
              };
              "ddg" = {
                urls = [
                  {
                    template = "https://duckduckgo.com/?q={searchTerms}";
                  }
                ];
                icon = "https://duckduckgo.com/favicon.ico";
              };
            };
          };
        };
      };
    };
  };

  stylix.targets.firefox.profileNames = [
    "base_profile"
  ];
  stylix.targets.firefox.colorTheme.enable = true;
}
