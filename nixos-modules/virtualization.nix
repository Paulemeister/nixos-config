{ pkgs, ... }:
{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.persistence."/persist".directories = [
    "/var/lib/waydroid"
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

}
