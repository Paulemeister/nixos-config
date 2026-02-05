{
  self,
  inputs,
  pkgs,
  ...
}:
let
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    "${self}/hosts/common"
    inputs.sidewinderd.nixosModules.sidewinderd
    ./hardware-configuration.nix
  ];

  environment.localBinInPath = true;

  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.scx.enable = true;

  networking.firewall.checkReversePath = false;

  services.flatpak.enable = true;

  # Prerequisite for allowOther for impermanence in home-manager for root acces to mounts
  programs.fuse.userAllowOther = true;

  # Don't lecture on first usage of sudo
  security.sudo.extraConfig = "Defaults lecture = never";

  security.polkit.enable = true;

  virtualisation.virtualbox.host.enable = true;

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

  networking.hostName = "theseus";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  # services.xserver.libinput.enable = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/nix"
      "/var/tmp"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }

    ];
    files = [
      # used by journald, regenerating doesn't assosiate logs
      # from previous boots together, even if the logs are
      # persistent
      "/etc/machine-id"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
