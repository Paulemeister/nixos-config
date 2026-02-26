{
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    ;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.distrobox.enable (mkMerge [
    {

      programs.distrobox = {
        enable = true;
        settings = {
          container_user_custom_home = "$HOME/.local/share/distrobox/$DBX_CONTAINER_NAME";
        };
      };
    }
    (mkIf cfg.usePersistence {

      home.persistence."/persist".directories = [
        ".local/share/containers"
        ".local/share/distrobox"
      ];
    })
  ]);

  options.pm-modules.distrobox.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      distrobox
    '';
  };
}
