{
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf true (mkMerge [
    (mkIf true {
      home.persistence."/persist".directories = [
        ".local/share/flatpak"
      ];
    })
  ]);

}
