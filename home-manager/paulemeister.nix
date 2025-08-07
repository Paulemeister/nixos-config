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
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
    ./cosmic-manager-settings.nix
    ./gnome.nix
    ./easyeffects.nix
    ./daw.nix
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
    pkgs-unstable.neofetch
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
    #    clang-tools
  ];

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
        rebuild-nix-config = "sudo nixos-rebuild --flake ~/Code/nixos-config switch --show-trace";
        open = "xdg-open";
      };
    };
    # SSH
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github" = {
          user = "git";
          hostname = "github.com";
          identityFile = "~/.ssh/id_ed25519";
          extraOptions = {
            "AddKeysToAgent" = "yes";
          };
        };
      };
    };
    mangohud = {
      enable = true;
      # enableSessionWide = true;
    };
  };

  # SSH agent for remebering ssh key passwords
  services.ssh-agent.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
