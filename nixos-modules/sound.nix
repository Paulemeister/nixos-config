{
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.sound.enable {

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    # services.pulseaudio.extraConfig = "load-module libpipewire-module-loopback";
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # extraConfig.pipewire."92-bluez-monitor" = {
      #   "bluez5.codecs" = ["sbc" "aac" "aptx" "aptx_hd" "ldac"];
      #   "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
      # };
      # wireplumber.extraConfig = {
      #   "log-level-debug" = {
      #     "context.properties" = {
      #       # Output Debug log messages as opposed to only the default level (Notice)
      #       "log.level" = "D";
      #     };
      #   };
      #   "93-auto-reload" = {
      #     "monitor.bluez.properties" = {
      #       "rescan-on-startup" = true;
      #       "rescan-interval-sec" = 10;
      #     };
      #   };
      #   "94-force-a2dp" = {
      #     "monitor.bluez.rules" = [
      #       {
      #         matches = [
      #           {
      #             "device.name" = "~bluez_card.*";
      #           }
      #         ];
      #         actions = {
      #           update-props = {
      #             # Set quality to high quality instead of the default of auto
      #             # "bluez5.a2dp.ldac.quality" = "hq";
      #             "bluez5.default.profile" = "a2dp-sink";
      #             "bluez5.profile-lock" = true;
      #           };
      #         };
      #       }
      #     ];
      #   };
      #   "95-prefer-a2dp" = {
      #     "monitor.bluez.properties" = {
      #       "PreferAudioProfile" = "a2dp-sink";
      #     };
      #   };
      #   "96-bluetooth-policy" = {
      #     "wireplumber.settings" = {
      #       "bluetooth.autoswitch-to-headset-profile" = false;
      #     };
      #   };
      # };
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };
  options.pm-modules.sound.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      enable sound
    '';
  };
}
