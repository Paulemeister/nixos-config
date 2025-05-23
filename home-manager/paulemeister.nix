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
  imports = [];

  home = {
    username = "paulemeister";
    homeDirectory = "/home/paulemeister";
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
        edit-nix-config = "hx ~/.dotfiles/nixos-config";
        rebuild-nix-config = "sudo nixos-rebuild --flake ~/.dotfiles/nixos-config switch --show-trace";
      };
    };
  };

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
