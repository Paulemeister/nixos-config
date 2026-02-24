{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.gaming.enable {
    hardware.xpadneo.enable = true;
    # Setup for Gaming
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          export MANGOHUD=1
        '';
      };
      gamescopeSession.enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  options.pm-modules.gaming.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      add steam and xpadneo
    '';
  };
}
