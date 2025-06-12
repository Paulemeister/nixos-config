{
  pkgs,
  config,
  ...
}: {
  # add shell extensions packages
  home.packages = with pkgs.gnomeExtensions; [
    vertical-workspaces
    forge
    dash-to-dock
    appindicator
    # add dconf editor
    pkgs.dconf-editor
  ];
  # Configure dconf settings for gnome
  dconf = {
    enable = true;
    settings = {
      # Color scheme
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      ########### Shortcuts ############
      # Launching Applications
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Super>t";
        command = "kgx";
        name = "Open Terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser" = {
        binding = "<Super>b";
        command = "firefox";
        name = "Open Firefox";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files" = {
        binding = "<Super>f";
        command = "nautilus -w";
        name = "Open File Manager";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/mail" = {
        binding = "<Super>e";
        command = "thunderbird";
        name = "Open E-Mail Client";
      };
      # Set apps in dock
      "org/gnome/shell" = {
        favorite-apps = ["firefox.desktop" "org.gnome.Console.desktop"];
      };
      # Window management
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-left = ["<Super><Control>Left"];
        switch-to-workspace-right = ["<Super><Control>Right"];
        switch-to-workspace-up = ["<Super><Control>Up"];
        switch-to-workspace-down = ["<Super><Control>Down"];
        move-to-workspace-left = ["<Super><Ctrl><Shift>Left"];
        move-to-workspace-right = ["<Super><Ctrl><Shift>Right"];
        move-to-workspace-up = ["<Super><Ctrl><Shift>Up"];
        move-to-workspace-down = ["<Super><Ctrl><Shift>Down"];
        minimize = ["<Super><Shift>m"];
        maximize = [];
        toggle-maximized = ["<Super>m"]; # opens calendar on top?
        close = ["<Super>q"];
      };
      ############ Misc ###############
      # Enable night light
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
      # Enable window snapping
      # "org/gnome/mutter" = {
      #   edge-tiling = true;
      # };
      # Disable greeting
      "org/gnome/shell" = {
        welcome-dialog-last-shown-version = pkgs.gnome-shell.version;
      };
      # Make EurKey show up / usable
      "org/gnome/desktop/input-sources".show-all-sources = true;
      # Disable dconf-editor startup warning
      "ca/desrt/dconf-editor".show-warning = false;

      # Enable extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          vertical-workspaces.extensionUuid
          forge.extensionUuid
          dash-to-dock.extensionUuid
          appindicator.extensionUuid
        ];
      };
      # Configure vertical workspaces
      "org/gnome/shell/extensions/vertical-workspaces" = {
        center-dash-to-ws = false;
        dash-position = 2;
        dash-position-adjust = 0;
        show-app-icon-position = 2;
        startup-state = 1;
        wst-position-adjust = 0;
      };
      # Configure forge (auto tiling)
      "org/gnome/shell/extensions/forge" = {
        dns-center-layout = "tabbed";
        stacked-tiling-mode-enabled = false;
        window-gap-size = 0;
      };
      # Configure dash to dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        show-trash = false;
        shortcut = [];
      };
    };
  };
  # Add styling for forge
  xdg.configFile."forge/stylesheet/forge/stylesheet.css" = {
    source = ./dotfiles/forge/stylesheet.css;
    force = true;
    # onChange = ''
    #   rm -f ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
    #   cp ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet_init.css ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
    #   chmod 0666 ${config.xdg.configHome}/forge/stylesheet/forge/stylesheet.css
    # '';
  };
  xdg.configFile."forge/config/windows.json" = {
    source = ./dotfiles/forge/windows.json;
    force = true;
  };
}
