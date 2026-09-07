{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.cachix.enable {

  };

  options.pm-modules.cachix = {
    enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        add cachix upload
      '';
    };
  };
}
