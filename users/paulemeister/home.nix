# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    # inputs.impermanence.homeManagerModules.impermanence
    # inputs.cosmic-manager.homeManagerModules.cosmic-manager
    # inputs.sidewinderd.homeManagerModules.sidewinderd
    "${self}/users/common/home.nix"
    inputs.lan-mouse.homeManagerModules.default
  ];

  programs.lan-mouse = {
    enable = true;
    package = pkgs.lan-mouse;
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "kitty.desktop" ];
    };
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
    persistence."/persist" = {
      hideMounts = true;
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
        ".config/mozilla"
        ".thunderbird"
        ".cache"
        ".config/eduvpn"
        ".local/state/syncthing"
        # ".config/sidewinderd"
        ".config/easyeffects"

        ".config/AusweisApp"
        ".config/OpenRGB"
        ".config/spotify"
        ".local/share/applications" # persist custom .desktop entries (quick-webapps)
        ".local/share/icons/QuickWebApps"
        ".local/share/quick-webapps"

      ];
      # allowOther = true;
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
    clinfo
    cpu-x
    packet
    # gnome-terminal
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
  home.sessionVariables.NIXOS_OZONE_WL = "1";

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
      settings.user = {
        email = "annanas6800i@gmail.com";
        name = "Paulemeister";
      };
    };
    # Bash aliases
    bash = {
      enable = true;
      shellAliases = {
        edit-nix-config = "hx $NH_FLAKE";
        # rebuild-nix-config = "sudo nixos-rebuild --flake ~/Code/nixos-config switch --show-trace";
        rebuild-nix-config = "nh os switch";
        sw-nix-config = "cd $NH_FLAKE && git status";
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

        # use ble.sh
        source ${pkgs.blesh}/share/blesh/ble.sh
        bleopt term_index_colors='0'
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
