{ pkgs, ... }:
{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  hardware.i2c.enable = true;
  services.udev.packages = [ pkgs.openrgb ];
}
