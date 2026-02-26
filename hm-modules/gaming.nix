{
  osConfig,
  lib,
  pkgs,
  config,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf osCfg.gaming.enable (mkMerge [
    {
      home.packages = with pkgs; [
        prismlauncher
      ];

      programs = {
        mangohud = {
          enable = true;
        };
      };

      stylix.targets.mangohud = {
        fonts.enable = false;
        opacity.enable = false;
      };
    }
    (mkIf cfg.usePersistence {
      home.persistence."/persist".directories = [
        {
          directory = ".local/share/Steam";
          # method = "symlink";
        }
      ];
    })
  ]);
}
