{ pkgs, ... }:
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
  ];

  home.persistence."/persist".directories = [

    ".config/discord"
    ".config/obsidian"

    ".config/Signal"
  ];

}
