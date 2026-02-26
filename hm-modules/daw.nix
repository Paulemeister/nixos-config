{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib)
    mkIf
    mkOption
    ;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.daw.enable {
    home.packages = with pkgs; [
      yabridge
      yabridgectl
    ];
  };

  options.pm-modules.daw.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      random cli tools
    '';
  };
}
