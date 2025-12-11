# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
    # inputs.cosmic-manager.homeManagerModules.cosmic-manager
    # ./modules/cosmic-manager-settings.nix
    ./modules/gnome.nix
    ./modules/easyeffects.nix
    ./modules/daw.nix
    ./modules/gaming.nix
    ./modules/programming.nix
    ./modules/hyprland.nix
    ./modules/cli-tools.nix
    ./modules/cosmic-epoch.nix
    ./modules/nix-tools.nix
    # ./modules/openrgb.nix
    # inputs.sidewinderd.homeManagerModules.sidewinderd
    inputs.lan-mouse.homeManagerModules.default
  ];

  programs.lan-mouse = {
    enable = true;
    package = pkgs.lan-mouse;
  };

  xsession.numlock.enable = true;
  services.syncthing.enable = true;

  # systemd.user.services.wireplumber.unitConfig = {
  #   After = ["bluetooth.service"];
  #   Wants = ["bluetooth.service"];
  # };

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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    signal-desktop
    discord
    (obsidian.overrideAttrs (p: rec {
      desktopItem = p.desktopItem.override (q: {
        # Use german local for proper date time picker in german (doesnt respect locale properly)
        exec = "env LANG=de_DE.UTF-8 LANGUAGE=de ${q.exec}";
      });

      installPhase = builtins.replaceStrings [ "${p.desktopItem}" ] [ "${desktopItem}" ] p.installPhase;
    }))
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
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      };
    };
    configFile."cosmic-initial-setup-done".text = "";
  };

  # fonts.fontconfig = {
  #   enable = true;
  #   defaultFonts.monospace = ["Fira Code"];
  # };

  # Add programs through modules
  programs = {
    home-manager.enable = true;

    thunderbird = {
      enable = true;
      profiles."Paul Budden" = {
        isDefault = true;
      };
    };

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
      # make bash reload home manager session variables
      initExtra = ''
        # include .profile if it exists
        if [ -f "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh" ]; then
          unset __HM_SESS_VARS_SOURCED
          source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
        fi
        bind -s 'set completion-ignore-case on'
        # fix for cosmic: get right socket (uses  /1000/keyring/ssh which doesnt exist)
        if command -v systemctl >/dev/null 2>&1; then
          sock="$(systemctl --user show-environment | grep '^SSH_AUTH_SOCK=' | cut -d= -f2-)"
          if [ -n "$sock" ]; then
            export SSH_AUTH_SOCK="$sock"
          fi
        fi
      '';
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
