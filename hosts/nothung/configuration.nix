{
  self,
  inputs,
  pkgs,
  ...
}:
let
  monitorsxml = pkgs.writeText "monitorsxml" ''
    <monitors version="2">
      <configuration>
        <layoutmode>logical</layoutmode>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1.3333333730697632</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>eDP-1</connector>
              <vendor>BOE</vendor>
              <product>0x0bca</product>
              <serial>0x00000000</serial>
            </monitorspec>
            <mode>
              <width>2256</width>
              <height>1504</height>
              <rate>59.999</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  '';
in
{
  imports = [
    "${self}/hosts/common"
    "${self}/nixos-modules/home-manager.nix"
    inputs.impermanence.nixosModules.impermanence
    inputs.sidewinderd.nixosModules.sidewinderd
    inputs.stylix.nixosModules.stylix
    "${self}/overlays/kgx-stylix-patch.nix"
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  pm-modules = {
    hm = true;
    usePersistence = true;
  };

  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    extraConfig = ''
      DeviceScale=1
    '';
  };

  systemd.tmpfiles.rules = [
    "L /run/gdm/.config/monitors.xml - - - - ${monitorsxml}"
  ];

  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer']
  '';

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.checkReversePath = false;

  services.flatpak.enable = true;

  services.journald = {
    extraConfig = "SystemMaxUse=1G";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Add OpenCL Support (for CPU-X)
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.consoleMode = "max";

  networking.hostName = "nothung";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "eu";

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
