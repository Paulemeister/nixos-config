{
  osConfig,
  lib,
  pkgs,
  config,
  self,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf osCfg.de.gnome.enable (mkMerge [
    (mkIf cfg.usePersistence {

      home.persistence."/persist" = {
        files = [
          ".config/gtk-3.0/bookmarks"
          # {
          #   file = ".config/gtk-4.0/servers";
          #   # method = "symlink";
          # }
        ];
        directories = [ ".config/gtk-4.0" ];
      };
    })
    {

      # add shell extensions packages
      home.packages = with pkgs.gnomeExtensions; [
        vertical-workspaces
        # forge
        dash-to-dock
        appindicator

        pop-shell # add dconf editor

        pkgs.dconf-editor
      ];
      # Configure dconf settings for gnome
      dconf = {
        enable = true;
        settings = {
          ############# from github: for pop-shell #################
          # Color scheme
          "org/gnome/desktop/interface" = {
            color-scheme = lib.mkDefault "prefer-dark";
          };
          "org/gnome/desktop/wm/keybindings" = {
            close = lib.mkDefault [
              "<Super>q"
              "<Alt>F4"
            ];
            minimize = lib.mkDefault [ "<Super>comma" ];
            toggle-maximized = lib.mkDefault [ "<Super>m" ];
            move-to-monitor-left = lib.mkDefault [ ];
            move-to-monitor-right = lib.mkDefault [ ];
            move-to-monitor-up = lib.mkDefault [ ];
            move-to-monitor-down = lib.mkDefault [ ];
            move-to-workspace-down = lib.mkDefault [ ];
            move-to-workspace-up = lib.mkDefault [ ];
            switch-to-workspace-down = lib.mkDefault [ "<Ctrl><Super>Down" ];
            switch-to-workspace-up = lib.mkDefault [ "<Ctrl><Super>Up" ];
            switch-to-workspace-left = lib.mkDefault [ ];
            switch-to-workspace-right = lib.mkDefault [ ];
            maximize = lib.mkDefault [ ];
            unmaximize = lib.mkDefault [ ];
          };

          "org/gnome/shell/keybindings" = {
            open-application-menu = lib.mkDefault [ ];
            toggle-message-tray = lib.mkDefault [ "<Super>v" ];
            toggle-overview = lib.mkDefault [ ];
          };

          "org/gnome/mutter/keybindings" = {
            toggle-tiled-left = lib.mkDefault [ ];
            toggle-tiled-right = lib.mkDefault [ ];
          };

          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = lib.mkDefault [ ];
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            screensaver = lib.mkDefault [ "<Super>Escape" ];
            home = lib.mkDefault [ "<Super>f" ];
            www = lib.mkDefault [ "<Super>b" ];
            # terminal = lib.mkDefault ["<Super>t"]; # doesn't seem to work
            email = lib.mkDefault [ "<Super>e" ];
            rotate-video-lock-static = lib.mkDefault [ ];
          };

          "org/gnome/shell/extensions/pop-shell" = {
            toggle-tiling = lib.mkDefault [ "<Super>y" ];
            toggle-floating = lib.mkDefault [ "<Super>g" ];
            tile-enter = lib.mkDefault [ "<Super>Return" ];
            tile-accept = lib.mkDefault [ "Return" ];
            tile-reject = lib.mkDefault [ "Escape" ];
            toggle-stacking-global = lib.mkDefault [ "<Super>s" ];
            pop-workspace-down = lib.mkDefault [
              "<Shift><Super>Down"
              "<Shift><Super>j"
            ];
            pop-workspace-up = lib.mkDefault [
              "<Shift><Super>Up"
              "<Shift><Super>k"
            ];
            pop-monitor-left = lib.mkDefault [
              "<Shift><Super>Left"
              "<Shift><Super>h"
            ];
            pop-monitor-right = lib.mkDefault [
              "<Shift><Super>Right"
              "<Shift><Super>l"
            ];
            pop-monitor-down = lib.mkDefault [ ];
            pop-monitor-up = lib.mkDefault [ ];
            focus-left = lib.mkDefault [
              "<Super>Left"
              "<Super>h"
            ];
            focus-down = lib.mkDefault [
              "<Super>Down"
              "<Super>j"
            ];
            focus-up = lib.mkDefault [
              "<Super>Up"
              "<Super>k"
            ];
            focus-right = lib.mkDefault [
              "<Super>Right"
              "<Super>l"
            ];
          };

          ########### Shortcuts ############
          # Launching Applications
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = lib.mkDefault [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
              #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser/"
              #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files/"
              #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail/"
            ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
            binding = lib.mkDefault "<Super>t";
            command = lib.mkDefault "${pkgs.kitty}/bin/kitty";
            name = lib.mkDefault "Open Terminal";
          };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser" = {
          #   binding = lib.mkDefault "<Super>b";
          #   command = lib.mkDefault "firefox";
          #   name = lib.mkDefault "Open Firefox";
          # };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files" = {
          #   binding = lib.mkDefault "<Super>f";
          #   command = lib.mkDefault "nautilus -w";
          #   name = lib.mkDefault "Open File Manager";
          # };
          # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail" = {
          #   binding = lib.mkDefault "<Super>e";
          #   command = lib.mkDefault "thunderbird";
          #   name = lib.mkDefault "Open E-Mail Client";
          # };
          # Set apps in dock
          "org/gnome/shell" = {
            favorite-apps = lib.mkDefault [
              "firefox.desktop"
              # "org.gnome.Console.desktop"
              "kitty.desktop"
            ];
          };
          # # Window management
          # "org/gnome/desktop/wm/keybindings" = {
          #   switch-to-workspace-left = lib.mkDefault ["<Super><Control>Left"];
          #   switch-to-workspace-right = lib.mkDefault ["<Super><Control>Right"];
          #   switch-to-workspace-up = lib.mkDefault ["<Super><Control>Up"];
          #   switch-to-workspace-down = lib.mkDefault ["<Super><Control>Down"];
          #   move-to-workspace-left = lib.mkDefault ["<Super><Ctrl><Shift>Left"];
          #   move-to-workspace-right = lib.mkDefault ["<Super><Ctrl><Shift>Right"];
          #   move-to-workspace-up = lib.mkDefault ["<Super><Ctrl><Shift>Up"];
          #   move-to-workspace-down = lib.mkDefault ["<Super><Ctrl><Shift>Down"];
          #   minimize = lib.mkDefault ["<Super><Shift>m"];
          #   maximize = lib.mkDefault [];
          #   toggle-maximized = lib.mkDefault ["<Super>m"]; # opens calendar on top?
          #   close = lib.mkDefault ["<Super>q"];
          # };
          ############ Misc ###############
          # Enable night light
          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = lib.mkDefault true;
          };
          # Disable screensaver shortcut (frees up pop shell vim keybinds)
          "org/gnome/settings-daemon/plugin/media-keys" = {
            screensaver = lib.mkDefault [ ];
          };
          "org/gnome/settings-daemon/plugins/housekeeping" = {
            donation-reminder-enabled = lib.mkDefault false;
          };
          # Fractional Scaling
          "org/gnome/mutter" = {
            experimental-features = lib.mkDefault [
              "scale-monitor-framebuffer"
              "xwayland-native-scaling"
            ];
          };
          # Nautilus folder view
          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
          };

          # Enable window snapping
          # "org/gnome/mutter" = {
          #   edge-tiling = lib.mkDefault true;
          # };
          # Disable greeting
          "org/gnome/shell" = {
            welcome-dialog-last-shown-version = lib.mkDefault pkgs.gnome-shell.version;
          };
          # Make EurKey show up / usable
          "org/gnome/desktop/input-sources".show-all-sources = true;
          # Disable dconf-editor startup warning
          "ca/desrt/dconf-editor".show-warning = false;

          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = lib.mkDefault true;
          };

          # Enable extensions
          "org/gnome/shell" = {
            disable-user-extensions = lib.mkDefault false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              vertical-workspaces.extensionUuid
              # forge.extensionUuid
              dash-to-dock.extensionUuid
              appindicator.extensionUuid
              pop-shell.extensionUuid
            ];
          };
          # Configure pop-shell
          "org/gnome/shell/extensions/pop-shell" = {
            gap-inner = lib.mkDefault 1;
            gap-outer = lib.mkDefault 1;
            tile-by-default = lib.mkDefault true;
          };
          # Configure vertical workspaces
          "org/gnome/shell/extensions/vertical-workspaces" = {
            center-dash-to-ws = lib.mkDefault false;
            dash-position = lib.mkDefault 2;
            dash-position-adjust = lib.mkDefault 0;
            show-app-icon-position = lib.mkDefault 2;
            startup-state = lib.mkDefault 1;
            wst-position-adjust = lib.mkDefault 0;
          };
          # Configure forge (auto tiling)
          # "org/gnome/shell/extensions/forge" = {
          #   dns-center-layout = lib.mkDefault "tabbed";
          #   stacked-tiling-mode-enabled = lib.mkDefault false;
          #   window-gap-size = lib.mkDefault 0;
          # };
          # Configure dash to dock
          "org/gnome/shell/extensions/dash-to-dock" = {
            show-trash = lib.mkDefault false;
            shortcut = lib.mkDefault [ ];
          };
        };
      };
      # Add styling for forge
      # xdg.configFile."forge/stylesheet/forge/stylesheet.css" = {
      #   source = ./dotfiles/forge/stylesheet.css;
      #   force = true;
      # onChange = ''
      #   rm -f ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
      #   cp ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet_init.css ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
      #   chmod 0666 ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
      # '';
      # };
      xdg.configFile."forge/config/windows.json" = {
        source = "${self}/misc/dotfiles/forge/windows.json";
        force = true;
      };
    }
  ]);
}
