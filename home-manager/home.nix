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
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  home = {
    username = "paulemeister";
    homeDirectory = "/home/paulemeister";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    nixd # nix language server
    alejandra # nix formatter
    pkgs-unstable.neofetch
    btop
    uv
    gh
  ];

  programs = {
    helix = {
      enable = true;
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

    # Enable home-manager and git
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "annanas6800i@gmail.com";
      userName = "Paulemeister";
    };
    bash = {
      enable = true;
      shellAliases = {
        edit-nix-config = "hx ~/.dotfiles/nixos-config";
        rebuild-nix-config = "sudo nixos-rebuild --flake ~/.dotfiles/nixos-config switch --show-trace";
      };
    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  dconf = {
    enable = true;
    settings = {
      #      "org/gnome/desktop/input-sources" = {
      #        show-all-sources = true;
      #        sources = [ (lib.gvariant.mkTuple [ "xkb" "eu" ]) ];
      #        xkb-options = [ ];
      #      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
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
      "org/gnome/mutter" = {
        edge-tiling = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
