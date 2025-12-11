{
  config,
  pkgs,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;

  patchTemplate = ./kgx.patch;

  # Hilfsfunktion für sed-Zeilen
  subst = name: value: "-e 's|${name}|${value}|'";

  # Base16 Farben: LIGHT_COLOR_00 … LIGHT_COLOR_15

  # lightColors =
  #   lib.concatStringsSep " "
  #   (lib.map
  #     (
  #       i: let
  #         num = lib.format "%02X" i;
  #       in
  #         subst "#LIGHT_COLOR_${num}#" colors."base${num}"
  #     )
  #     (lib.range 0 15));

  lightColors = lib.concatStringsSep " " (
    lib.imap0 (i: base: subst "#LIGHT_COLOR_${lib.strings.fixedWidthNumber 2 i}#" base) (colors.toList)
  );
  darkColors = lib.concatStringsSep " " (
    lib.imap0 (i: base: subst "#DARK_COLOR_${lib.strings.fixedWidthNumber 2 i}#" base) (colors.toList)
  );

  # Foreground/Background (hier einzeln, da RGBA-Struct)
  rgbaSubsts = lib.concatStringsSep " " [
    (subst "#LIGHT_FOREGRND_R#" (toString colors.base00-dec-r))
    (subst "#LIGHT_FOREGRND_G#" (toString colors.base00-dec-g))
    (subst "#LIGHT_FOREGRND_B#" (toString colors.base00-dec-b))
    (subst "#LIGHT_FOREGRND_A#" "1.0")
    (subst "#LIGHT_BACKGRND_R#" (toString colors.base05-dec-r))
    (subst "#LIGHT_BACKGRND_G#" (toString colors.base05-dec-g))
    (subst "#LIGHT_BACKGRND_B#" (toString colors.base05-dec-b))
    (subst "#LIGHT_BACKGRND_A#" "1.0")

    (subst "#DARK_FOREGRND_R#" (toString colors.base05-dec-r))
    (subst "#DARK_FOREGRND_G#" (toString colors.base05-dec-g))
    (subst "#DARK_FOREGRND_B#" (toString colors.base05-dec-b))
    (subst "#DARK_FOREGRND_A#" "1.0")
    (subst "#DARK_BACKGRND_R#" (toString colors.base00-dec-r))
    (subst "#DARK_BACKGRND_G#" (toString colors.base00-dec-g))
    (subst "#DARK_BACKGRND_B#" (toString colors.base00-dec-b))
    (subst "#DARK_BACKGRND_A#" "1.0")
  ];

  patchWithColors = pkgs.runCommand "kgx-theme-patch" { } ''
    sed ${lightColors} ${darkColors} ${rgbaSubsts} \
      ${patchTemplate} > $out
  '';
in
{
  nixpkgs.overlays = [
    (self: super: {
      gnome-console = super.gnome-console.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ patchWithColors ];
      });
    })
  ];
}
