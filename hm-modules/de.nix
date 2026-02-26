{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  inherit (lib) mkIf;
in
{
  config = mkIf osCfg.gui {
    home.packages = with pkgs; [
      adwaita-icon-theme-legacy
      adwaita-icon-theme
      hicolor-icon-theme
    ];
  };
}
