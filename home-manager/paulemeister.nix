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
  ];

  home = {
    username = "paulemeister";
    homeDirectory = "/home/paulemeister";
    persistence."/persist/home/paulemeister/" = {
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
        ".local/share"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        ".mozilla"
      ];
      allowOther = true;
    };
  };

  # Add packages
  home.packages = with pkgs; [
    nixd # nix language server
    alejandra # nix formatter
    pkgs-unstable.neofetch
    btop
    uv
    gh
    tlrc
  ];

  # Add programs through modules
  programs = {
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
  };

  # SSH agent for remebering ssh key passwords
  services.ssh-agent.enable = true;

  # Configure Gnome
  dconf = {
    enable = true;
    settings = {
      # Color scheme
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      # Shortuts
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "Open Terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>b";
        command = "firefox";
        name = "Open Firefox";
      };
      # Misc
      "org/gnome/mutter" = {
        edge-tiling = true;
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
