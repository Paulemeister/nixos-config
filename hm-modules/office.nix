{
  lib,
  pkgs,
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
  config = mkIf cfg.office.enable (mkMerge [
    {
      programs.onlyoffice.enable = true;

      home.packages = with pkgs; [
        signal-desktop
        discord
        (obsidian.overrideAttrs (p: rec {
          desktopItem = p.desktopItem.override (q: {
            # Use german local for proper date time picker in german (doesnt respect locale properly)
            exec = "env LANG=de_DE.UTF-8 LANGUAGE=de ${q.exec}";
          });

          installPhase = builtins.replaceStrings [ "${p.desktopItem}" ] [ "${desktopItem}" ] p.installPhase;
        }))

        moodle-dl
        # evince
        papers
      ];
    }
    (mkIf cfg.usePersistence {

      home.persistence."/persist".directories = [

        ".config/discord"
        ".config/obsidian"
        ".config/Signal"
      ];
    })
  ]);
  options.pm-modules.office.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      random office programs
    '';
  };
}
