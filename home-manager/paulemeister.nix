# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
    # inputs.cosmic-manager.homeManagerModules.cosmic-manager
    # ./cosmic-manager-settings.nix
    ./gnome.nix
    ./easyeffects.nix
    ./daw.nix
    ./gaming.nix
    ./programming.nix
    ./hyprland.nix
    ./cli-tools.nix
    # ./openrgb.nix
    # inputs.sidewinderd.homeManagerModules.sidewinderd
  ];

  # services.sidewinderd = {
  #   enable = true;
  #   settings.capture_delays = false;
  # };

  xsession.numlock.enable = true;

  services.syncthing.enable = true;

  home = {
    username = "paulemeister";
    homeDirectory = "/home/paulemeister";
    persistence."/persist/home/paulemeister" = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        "Code"
        ".ssh"
        ".local/share/keyrings"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        ".mozilla"
        ".thunderbird"
        ".cache"
        ".config/obsidian"
        ".config/eduvpn"
        ".config/Signal"
        ".local/state/syncthing"
        # ".config/sidewinderd"
        ".config/easyeffects"
        ".config/discord"
        ".config/obsidian"
        ".config/cosmic" # give up on cosmic-manager, as it has bugs when reloading home-manager -> dissapearing panels
        ".config/AusweisApp"
        ".config/OpenRGB"
        ".config/spotify"
        ".local/share/applications" # persist custom .desktop entries (quick-webapps)
      ];
      allowOther = true;
      files = [
        ".bash_history"
        ".config/monitors.xml" # Gnome refresh rate
      ];
    };
  };

  # Add packages

  home.packages = with pkgs; [
    nixd # nix language server
    alejandra # nix formatter
    fastfetch
    uv
    gh
    tlrc
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    signal-desktop
    discord
    (obsidian.overrideAttrs
      (p: rec {
        desktopItem = p.desktopItem.override (q: {
          # Use german local for proper date time picker in german (doesnt respect locale properly)
          exec = "env LANG=de_DE.UTF-8 LANGUAGE=de ${q.exec}";
        });

        installPhase = builtins.replaceStrings ["${p.desktopItem}"] ["${desktopItem}"] p.installPhase;
      }))
    nix-output-monitor
    clinfo
    cpu-x
    packet
    gnome-terminal
    quick-webapps
    spotify
    # nerd-fonts.fira-code
    # fira-co
  ];

  # set default app for .zip
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/zip" = ["org.gnome.FileRoller.desktop"];
      };
    };
  };

  # fonts.fontconfig = {
  #   enable = true;
  #   defaultFonts.monospace = ["Fira Code"];
  # };

  # Add programs through modules
  programs = {
    btop = {
      enable = true;
      settings = {
        vim_keys = false;
      };
    };
    thunderbird = {
      enable = true;
      profiles."Paul Budden" = {
        isDefault = true;
      };
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        editor.line-number = "relative";
      };
      languages.language = [
        {
          name = "nix";
          language-servers = ["nixd" "nil"];
          formatter.command = "alejandra";
          auto-format = true;
        }
      ];
    };

    home-manager.enable = true;

    git = {
      enable = true;
      userEmail = "annanas6800i@gmail.com";
      userName = "Paulemeister";
    };
    # Bash aliases
    bash = {
      enable = true;
      shellAliases = {
        edit-nix-config = "hx ~/Code/nixos-config";
        # rebuild-nix-config = "sudo nixos-rebuild --flake ~/Code/nixos-config switch --show-trace";
        rebuild-nix-config = "nh os switch";
        open = "xdg-open";
      };
    };
    # SSH
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github" = {
          user = "git";
          hostname = "github.com";
          identityFile = "~/.ssh/id_ed25519";
          extraOptions = {
            "AddKeysToAgent" = "yes";
          };
        };
        "*" = {
          # Default Values
          forwardAgent = false;
          addKeysToAgent = "yes"; # Not Default
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      };
    };
    mangohud = {
      enable = true;
      # enableSessionWide = true;
    };
    nh = {
      enable = true;
      flake = "/home/paulemeister/Code/nixos-config";
    };
    yazi.enable = true;
    # gnome-terminal = {
    #   enable = true;
    #   package = pkgs.gnome-terminal;
    # };
  };

  # setup packet (quick share)
  dconf.settings = {
    "io/github/nozwock/Packet"."enable-static-port" = true;
  };

  # SSH agent for remembering ssh key passwords
  services.ssh-agent.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
