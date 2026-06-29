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

    hardware.openrazer = {
      enable = true;
      users = [ "paulemeister" ];
    };
  };

  options.pm-modules.rgb.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      openrgb, currently only amd motherboard
    '';
  };
}
