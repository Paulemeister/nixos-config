{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-chaotic,
  inputs,
  lib,
  ...
}: let
in {
  imports = [];

  nix.settings = {
    trusted-users = ["root" "paulemeister"];
    # build-dir = /var/tmp/nix;
  };

  environment.localBinInPath = true;
  # services.open-webui = {
  #   enable = true;
  # };
  # services.ollama = {
  #   enable = true;
  #   acceleration = "rocm";
  #   # package = pkgs.ollama-rocm;
  #   rocmOverrideGfx = "10.3.0";
  # };
  # services.blueman.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.urserver.enable = true;

  systemd.user.services.urserver.wantedBy = lib.mkForce [];

  stylix = {
    enable = true;
    polarity = "dark";
    image = ../misc/wallpaper.jpg;
    base16Scheme = "${pkgs-unstable.base16-schemes}/share/themes/0x96f.yaml";
    # base16Scheme = "${pkgs-unstable.base16-schemes}/share/themes/default-dark.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.fira-sans;
        name = "Fira Sans";
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = {
        package = pkgs.nerd-fonts.fira-mono;
        name = "Fira Mono";
      };
    };
  };
  networking = {
    nameservers = ["127.0.0.1" "::1"];
    # If using NetworkManager:
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy = {
    enable = true;
    # Settings reference:
    # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      # Add this to test if dnscrypt-proxy is actually used to resolve DNS requests
      query_log.file = "/var/log/dnscrypt-proxy/query.log";
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        # "cloudflare"
        "quad9-dnscrypt-ip4-nofilter-pri"
        "quad9-dnscrypt-ip6-nofilter-pri"
      ];
    };
  };
  services.fwupd.enable = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  hardware.i2c.enable = true;
  services.udev.packages = [pkgs.openrgb];

  # systemd.services.no-rgb = {
  #   description = "no-rgb";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.openrgb}/bin/openrgb --mode static --color 000000";
  #     Type = "oneshot";
  #   };
  #   wantedBy = ["multi-user.target"];
  # };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.scx.enable = true;

  networking.firewall.checkReversePath = false;
  environment.systemPackages = with pkgs; [wl-clipboard];

  hardware.xpadneo.enable = true;
  services.flatpak.enable = true;

  # Prerequisite for allowOther for impermanence in home-manager for root acces to mounts
  programs.fuse.userAllowOther = true;

  # Enable dynamic linking fix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # dynamic libs go here
  ];

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  # Open port for packet (quick share)
  networking.firewall.allowedTCPPorts = [9300];

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

  services.journald = {
    extraConfig = "SystemMaxUse=1G";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Add OpenCL Support (for CPU-X)
    extraPackages = with pkgs; [rocmPackages.clr.icd];
  };

  # Siderwinderd Setup
  nixpkgs.overlays = [
    inputs.sidewinderd.overlays.default
    inputs.hyprcorners.overlays.default
  ];
  services.sidewinderd = {
    enable = true;
    settings = {
      capture_delays = false;
    };
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    videoDrivers = ["amdgpu"];
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
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

  services.blueman.enable = true;
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
  };

  security.rtkit.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paulemeister = {
    isNormalUser = true;
    description = "Paulemeister";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "plugdev" "input" "audio" "i2c"];
    hashedPasswordFile = "/persist/passwords/paulemeister";
  };

  # Set account picture
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
      "/var/lib/sidewinderd" # sidewinder configs
      {
        directory = "/var/lib/private/ollama";
        mode = "0700";
      }
      "/var/lib/private/open-webui"
    ];
    files = [
      # used by journald, regenerating doesn't assosiate logs
      # from previous boots together, even if the logs are
      # persistent
      "/etc/machine-id"
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
