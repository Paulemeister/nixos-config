{
  self,
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf;
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
  ];

  pm-modules = {
    phoneControl.enable = true;
    gaming.enable = true;
    rgb.enable = true;
    hm = true;
    usePersistence = true;
    theseusPeripherals.enable = true;
  };

  services.ollama = mkIf cfg.ai.enable {
    acceleration = "rocm";
    # package = pkgs.ollama-rocm;
    rocmOverrideGfx = "10.3.0";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Add OpenCL Support (for CPU-X)
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # what does this do?
  networking.firewall.checkReversePath = false;

  services.flatpak.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.consoleMode = "max";

  networking.hostName = "theseus";

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
