{
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) bool;
in
{
  imports = [
    ./bluetooth.nix
    ./desktop-manager.nix
    ./dns.nix
    ./gaming.nix
    ./nix-settings.nix
    ./phone-control.nix
    ./programs.nix
    ./rgb.nix
    ./sound.nix
    ./stylix.nix
    ./theseus-peripherals.nix
    ./virtualization.nix
    ./appimages.nix
    ./flatpak.nix
  ];

  options.pm-modules = {
    enable = mkEnableOption "paulemeister modules";
    enableDefault = mkOption {
      type = bool;
      default = true;
      description = ''
        Enable default modules (pretty much random)
      '';
    };
    usePersistence = mkEnableOption "Persist used files with persistence flake";
    gui = mkOption {
      type = bool;
      default = true;
      description = ''
        gui
      '';
    };
    hm = mkEnableOption "home-manager";
    simulation-tools.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        paraview
      '';
    };

    daw.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        daw
      '';
    };

    easyeffects.enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        easyeffects
      '';
    };

  };
}
