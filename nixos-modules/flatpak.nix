{
  config,
  lib,
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
  config = mkIf cfg.flatpak.enable (mkMerge [
    (mkIf cfg.usePersistence {
      environment.persistence."/persist".directories = [
        "/var/lib/flatpak"
      ];
    })
    { services.flatpak.enable = true; }

  ]);

  options.pm-modules.flatpak.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      flatpak
    '';
  };
}
