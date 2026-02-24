{
  self,
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  imports = [
    "${self}/users/common"
    "${self}/nixos-modules"
    # inputs.chaotic.nixosModules.nyx-cache
    # inputs.chaotic.nixosModules.nyx-overlay
    # inputs.chaotic.nixosModules.nyx-registry

  ];

  config = mkMerge [
    {

      # Don't lecture on first usage of sudo
      security.sudo.extraConfig = "Defaults lecture = never";

      environment.localBinInPath = true;

      services.fwupd.enable = true;

      services.scx.enable = true;

      # Prerequisite for allowOther for impermanence in home-manager for root acces to mounts
      programs.fuse.userAllowOther = true;

      security.polkit.enable = lib.mkDefault cfg.gui;

      services.journald = {
        extraConfig = "SystemMaxUse=1G";
      };
    }
    (mkIf cfg.usePersistence {
      environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
          "/nix"
          "/var/tmp"
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/fprint"
          "/var/lib/power-profiles-daemon"
          "/var/lib/fwupd"
          "/etc/NetworkManager/system-connections"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }

        ];
        files = [
          # used by journald, regenerating doesn't assosiate logs
          # from previous boots together, even if the logs are
          # persistent
          "/etc/machine-id"
        ];
      };
    })
  ];
}
