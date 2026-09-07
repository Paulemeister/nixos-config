{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf osCfg.cachix.enable (mkMerge [
    (mkIf cfg.usePersistence {
      home.persistence."/persist" = {
        files = [
          ".config/cachix/cachix.dhall"
        ];
      };
    }

    )

    {
      home.packages = [ pkgs.cachix ];

      systemd.user.services.cachix-watch-store = {
        Unit = {
          Description = "Cachix Store Watcher";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };

        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          ExecStart = "${pkgs.cachix}/bin/cachix watch-store paulemeister";
          Restart = "always";
          RestartSec = "5s";
        };
      };
    }
  ]);
}
