{
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.easyeffects.enable {
    services.easyeffects = {
      enable = true;
      extraPresets = {
        m-track_duo = {
          input = {
            "blocklist" = [ ];
            "plugins_order" = [
              "stereo_tools#0"
              "autogain#0"
              "rnnoise#0"
              "deepfilternet#0"
            ];

            "stereo_tools#0" = {
              "balance-in" = 0.0;
              "balance-out" = 0.0;
              "bypass" = false;
              "delay" = 0.0;
              "input-gain" = 0.0;
              "middle-level" = 0.0;
              "middle-panorama" = 0.0;
              "mode" = "LR > LL (Mono Left Channel)";
              "mutel" = false;
              "muter" = false;
              "output-gain" = 0.0;
              "phasel" = false;
              "phaser" = false;
              "sc-level" = 1.0;
              "side-balance" = 0.0;
              "side-level" = 0.0;
              "softclip" = false;
              "stereo-base" = 0.0;
              "stereo-phase" = 0.0;
            };
            "autogain#0" = {
              "bypass" = false;
              "input-gain" = 0.0;
              "maximum-history" = 15;
              "output-gain" = 0.0;
              "reference" = "Geometric Mean (MSI)";
              "silence-threshold" = -70.0;
              "target" = -23.0;
            };

            "rnnoise#0" = {
              "bypass" = false;
              "enable-vad" = true;
              "input-gain" = 0.0;
              "model-name" = "";
              "output-gain" = 0.0;
              "release" = 20.0;
              "vad-thres" = 5.0;
              "wet" = 0.0;
            };
            "deepfilternet#0" = {
              "attenuation-limit" = 100.0;
              "max-df-processing-threshold" = 20.0;
              "max-erb-processing-threshold" = 30.0;
              "min-processing-buffer" = 0;
              "min-processing-threshold" = -10.0;
              "post-filter-beta" = 0.02;
            };
          };
        };
      };
    };
  };
  options.pm-modules.easyeffects.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      distrobox
    '';
  };
}
