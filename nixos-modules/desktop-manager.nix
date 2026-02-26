{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    ;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.gui (mkMerge [
    {
      # Enable the X11 windowing system.
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };

      environment.systemPackages = with pkgs; [ wl-clipboard ];

      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      # for desktop portals? double check not needed?
      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    }
    (mkIf cfg.de.hyprland.enable {
      nixpkgs.overlays = [
        inputs.hyprcorners.overlays.default
      ];
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    })
    (mkIf cfg.de.cosmic.enable {

      services.desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
    })
    (mkIf cfg.de.gnome.enable {

      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      environment.gnome.excludePackages = with pkgs; [
        gnome-maps
        gnome-clocks
        gnome-contacts
        gnome-calendar
        gnome-software
        gnome-tour
        gnome-weather
        gnome-connections
        gnome-initial-setup
        gnome-logs
        gnome-characters
        gnome-user-docs
        gnome-browser-connector
        gnome-console
        cheese
        epiphany
        geary
        simple-scan
        papers
      ];
    })
  ]);

  options.pm-modules.de = {
    gnome.enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        enable gnome
      '';
    };

    hyprland.enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        enable hyprland
      '';
    };

    cosmic.enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        enable cosmic
      '';
    };

    default = mkOption {
      type = lib.types.str;
      default = "gnome";
      description = ''
        value used in gdm config for default de
      '';
    };
  };
}
