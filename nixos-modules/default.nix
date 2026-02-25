{
  lib,
  ...
}:
let
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
  };
}
