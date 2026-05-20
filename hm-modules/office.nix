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
  mypapers = pkgs.unstable.papers.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "balooii";
      repo = "papers";
      rev = "wip/balooii/improve_page_rendering_quality_for_fractional_scales";
      # The hash must be updated. Setting a dummy hash forces Nix to
      # report the correct one on the first attempt.
      hash = "sha256-ANU5/0zDz7L00i+nW2xOOGUnhlP6cCPasUaSrsfHgsE=";
    };
    cargoDeps = pkgs.unstable.rustPlatform.fetchCargoVendor {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "balooii";
        repo = "papers";
        rev = "wip/balooii/improve_page_rendering_quality_for_fractional_scales";
        # The hash must be updated. Setting a dummy hash forces Nix to
        # report the correct one on the first attempt.
        hash = "sha256-ANU5/0zDz7L00i+nW2xOOGUnhlP6cCPasUaSrsfHgsE=";
      };
      version = oldAttrs.version;
      hash = "sha256-gdxkaLMI9kh6vPTjmDEc1G8b/fPLdX2GidtRuum7xvA=";
    };
  });
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
        mypapers
        celluloid
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
