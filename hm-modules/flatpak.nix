{
  osConfig,
  lib,
  config,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf osCfg.flatpak.enable (mkMerge [
    (mkIf cfg.usePersistence {
      home.persistence."/persist".directories = [
        ".local/share/flatpak"
      ];
    })
  ]);

}
