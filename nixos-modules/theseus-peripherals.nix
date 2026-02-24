{
  config,
  lib,
  inputs,
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
  config = mkIf cfg.theseusPeripherals.enable (mkMerge [
    {
      # Siderwinderd Setup
      nixpkgs.overlays = [
        inputs.sidewinderd.overlays.default
      ];
      services.sidewinderd = {
        enable = true;
        settings = {
          capture_delays = false;
        };
      };
    }
    (mkIf cfg.usePersistence {
      environment.persistence."/persist".directories = [
        "/var/lib/sidewinderd" # sidewinder configs
      ];
    })
    {
      # systemd.services.no-rgb = {
      #   description = "no-rgb";
      #   serviceConfig = {
      #     ExecStart = "${pkgs.openrgb}/bin/openrgb --mode static --color 000000";
      #     Type = "oneshot";
      #   };
      #   wantedBy = ["multi-user.target"];
      # };

      programs.coolercontrol.enable = true;
    }
  ]);
  options.pm-modules.theseusPeripherals.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      bad module for theseus, sidewinderd and coolercontrol
    '';
  };
}
