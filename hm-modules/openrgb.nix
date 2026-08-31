{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.pm-modules;
  osCfg = osConfig.pm-modules;
  inherit (lib) mkIf mkOption mkMerge;
  inherit (lib.types) bool;

  # myScript = pkgs.writeShellScriptBin "set-mouse-rgb" ''
  #   #!/usr/bin/env bash
  #   set -euo pipefail
  #   COLOR="FF0000"
  #   mapfile -t MOUSE_DEVICES < <(
  #     ${pkgs.openrgb}/bin/openrgb --list-devices | awk '
  #     /^[0-9]+:/ {
  #         name=$0
  #         sub("^[0-9]+: ", "", name)
  #     }
  #     /^  Type:/ {
  #         if ($2 == "Mouse") {
  #             print name
  #         }
  #     }'
  #   )
  #   openrgb --color "000000"
  #   if [ ''\${#MOUSE_DEVICES[@]} -eq 0 ]; then
  #     echo "Keine Maus-Geräte gefunden."
  #     exit 0
  #   fi
  #   CMD=("${pkgs.openrgb}/bin/openrgb" )
  #   for dev in "''\${MOUSE_DEVICES[@]}"; do
  #     CMD+=(--device "$dev" --color "$COLOR")
  #   done
  #   echo "Führe aus: ''\${CMD[*]}"
  #   "''\${CMD[@]}"
  # '';
in
{
  config = mkMerge [
    (mkIf cfg.openrgb.enable {
      # home.packages = [myScript];

      # systemd user service
      systemd.user.services.setMouseRGB = {
        Unit = {
          Description = "Setzt Maus RGB bei Login";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.openrgb}/bin/openrgb -vv -p ~/.config/OpenRGB/mouse_only.orp";
          Type = "oneshot";
          PrivateDevices = "no";
          DeviceAllow = [
            "/dev/i2c-* rw"
            "/dev/hidraw* rw"
          ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    })
    # (mkIf osCfg.rgb.enable {
    #   home.packages = [ pkgs.polychromatic ];
    #   home.persistence."/persist".directories = [
    #     ".config/polychromatic"
    #     ".config/openrazer"
    #   ];

    # })

  ];
  options.pm-modules.openrgb.enable = mkOption {
    type = bool;
    default = osCfg.rgb.enable;
    description = ''
      openrgb
    '';
  };
}
