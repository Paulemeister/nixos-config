{
  osConfig,
  lib,
  ...
}:
let
  cfg = osConfig.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf cfg.flatpak.enable (mkMerge [
    (mkIf cfg.usePersistence {
      home.persistence."/persist".directories = [
        ".local/share/flatpak"
      ];
    })
  ]);

}
