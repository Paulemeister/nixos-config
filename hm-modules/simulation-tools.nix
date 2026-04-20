{
  lib,
  inputs,
  osConfig,
  config,
  pkgs,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  cfg = config.pm-modules;
  inherit (lib) mkIf mkMerge;

  paraview-5-13 =
    pkgs.runCommand "paraview-5-13"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/bin
        mkdir -p $out/share/applications

        # 1. Create a symlink for the main binary with the new name
        # This points directly to the real binary in the original store path
        ln -s ${
          inputs.nixpkgs-paraview-5-13-2.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paraview
        }/bin/paraview $out/bin/paraview-5-13

        # 2. Copy and edit the desktop file
        # We find the desktop file in the original package
        DESKTOP_SRC="${
          inputs.nixpkgs-paraview-5-13-2.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paraview
        }/share/applications/org.paraview.ParaView.desktop"

        cp "$DESKTOP_SRC" $out/share/applications/paraview-5-13.desktop
        chmod +w $out/share/applications/paraview-5-13.desktop

        sed -i 's|^Exec=paraview|Exec=paraview-5-13|g' $out/share/applications/paraview-5-13.desktop
        sed -i 's|^TryExec=paraview|TryExec=paraview-5-13|g' $out/share/applications/paraview-5-13.desktop
        sed -i 's|^Name=ParaView|Name=ParaView 5.13|g' $out/share/applications/paraview-5-13.desktop
      '';
in
{
  config = mkIf osCfg.simulation-tools.enable (mkMerge [
    {
      home.packages = with pkgs; [
        paraview-5-13
        paraview
        octaveFull
      ];
    }
    (mkIf cfg.usePersistence {
      home.persistence."/persist".directories = [
        ".config/octave"
        ".local/share/octave"
      ];
    })
  ]);
}
