{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    ;
  inherit (lib.types) bool;
in
{
  config = mkMerge [
    {
      virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      virtualisation.virtualbox.host.enable = true;
    }
    (mkIf cfg.usePersistence {
      environment.persistence."/persist".directories = [
        "/var/lib/waydroid"
      ];
    })
  ];
  options.pm-modules.virtualisation.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      enable waydroid, podman
    '';
  };
}
