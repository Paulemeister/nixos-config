{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
in {
  imports = [];

  # Enable num lock early on boot
  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.kbd}/bin/setleds
  '';
  boot.initrd.preDeviceCommands = ''
    INITTY=/dev/tty[1-6]
    for tty in $INITTY; do
      /bin/setleds -D +num < $tty
    done
  '';

  networking.firewall.checkReversePath = false;
  environment.systemPackages = with pkgs; [wl-clipboard];

  hardware.xpadneo.enable = true;
  services.flatpak.enable = true;

  # Prerequisite for allowOther for impermanence in home-manager for root acces to mounts
  programs.fuse.userAllowOther = true;

  # Don't lecture on first usage of sudo
  security.sudo.extraConfig = "Defaults lecture = never";

  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  virtualisation.virtualbox.host.enable = true;

  # Setup for Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Siderwinderd Setup
  nixpkgs.overlays = [inputs.sidewinderd.overlays.default];
  # services.sidewinderd.enable = true;
  services.sidewinderd = {
    enable = true;
    settings = {
      capture_delays = false;
    };
  };
  # services.sidewinderd.addUdevRule = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "theseus"; # Define your hostname.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-maps
    gnome-clocks
    gnome-contacts
    gnome-calendar
    gnome-software
    gnome-tour
    gnome-weather
    gnome-connections
    gnome-initial-setup
    gnome-logs
    gnome-characters
    gnome-user-docs
    gnome-browser-connector
    cheese
    epiphany
    geary
    simple-scan
  ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "eu";

  # Configure console keymap
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # services.pulseaudio.extraConfig = "load-module libpipewire-module-loopback";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    extraConfig.pipewire = {
      "split-m-track-duo" = {
        context.modules = [
          {
            name = "libpipewire-module-loopback";
            matches = [{device.name = "alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo";}];
            args = {
              node.description = "M-Audio M-Track Duo Channel 1";
              node.name = "m-track_ch_1";
              capture.props = {
                audio.position = ["FL"];
                stream.dont-remix = true;
                target.object = "alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo";
                node.passive = true;
              };
              playback.props = {
                media.class = "Audio/Source";
                audio.position = ["MONO"];
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            matches = [{device.name = "alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo";}];
            args = {
              node.description = "M-Audio M-Track Duo Channel 2";
              node.name = "m-track_ch_2";
              capture.props = {
                audio.position = ["FR"];
                stream.dont-remix = true;
                target.object = "alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo";
                node.passive = true;
              };
              playback.props = {
                media.class = "Audio/Source";
                audio.position = ["MONO"];
              };
            };
          }
        ];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paulemeister = {
    isNormalUser = true;
    description = "paulemeister";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "plugdev" "input" "audio"];
    hashedPasswordFile = "/persist/passwords/paulemeister";
  };

  system.activationScripts.script.text = let
    name = "paulemeister";
  in ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${../home-manager/dotfiles/paulemeister-icon} /var/lib/AccountsService/icons/${name}
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${name}\n" > /var/lib/AccountsService/users/${name}

    chown root:root /var/lib/AccountsService/users/${name}
    chmod 0600 /var/lib/AccountsService/users/${name}

    chown root:root /var/lib/AccountsService/icons/${name}
    chmod 0444 /var/lib/AccountsService/icons/${name}
  '';

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/nix"
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
      "/var/lib/sidewinderd" # sidewinder configs
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
