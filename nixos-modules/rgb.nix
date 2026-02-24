{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in
{
  config = {
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    hardware.i2c.enable = true;
    services.udev.packages = [ pkgs.openrgb ];
  };

  options.pm-modules.rgb.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      openrgb, currently only amd motherboard
    '';
  };
}
