{
  ...
}:
{
  # services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # settings = {
    #   General = {
    #     Enable = "Source,Sink,Media,Socket";
    #     Experimental = true;
    #   };
    #   Policy = {
    #     ReconnectAttemps = 7;
    #     ReconnectIntervals = "1,2,4,8,16,64";
    #     ReconnectUUIDs = "0000110d-0000-1000-8000-00805f9b34fb,0000110e-0000-1000-8000-00805f9b34fb";
    #   };
    # };
    # settings = {
    #   General = {
    #     # 🔴 DAS ist der entscheidende Teil
    #     Enable = "Source,Sink,Media";

    #     # Optional, aber empfohlen
    #     Disable = "Handsfree,Headset";
    #   };
    # };
  };
  # ChatGPT says this disables the "Hands-Free Profile"
  # which apparently will be done in gnome
  # this is supposed to fix the headset cutting out
  # because it supposedly sends requests switching to it
  # services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
  #   "monitor.bluez.properties" = {
  #     "bluez5.enable-hfp" = false;
  #     "bluez5.enable-hsp" = false;
  #   };
  # };
  # ChatGTP conversion o f
  services.pipewire.wireplumber.extraConfig = {
    "51-mitigate-annoying-profile-switch" = {
      "wireplumber.settings.bluetooth" = {
        autoswitch-to-headset-profile = false;
      };

      "monitor.bluez.properties" = {
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
        ];

        "bluez5.enable-hfp" = false;
        "bluez5.enable-hsp" = false;
      };
    };
  };
}
