{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  inherit (lib) mkIf;
in
{
  config = mkIf osCfg.daw.enable {
    home.packages = with pkgs; [
      yabridge
      yabridgectl
    ];
  };

}
