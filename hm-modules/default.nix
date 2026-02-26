{
  lib,
  osConfig,
  ...
}:
let
  osCfg = osConfig.pm-modules;
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in
{
  imports = [
    ./cli-tools.nix
    ./cosmic-epoch.nix
    ./daw.nix
    ./de.nix
    ./distrobox.nix
    ./easyeffects.nix
    ./flatpak.nix
    ./gaming.nix
    ./gnome.nix
    ./hyprland.nix
    ./kitty.nix
    ./nix-tools.nix
    ./office.nix
    ./openrgb.nix
    ./programming.nix
  ];

  options.pm-modules = {
    enableDefault = mkOption {
      type = bool;
      default = true;
      description = ''
        enable default home-manager modules (random)
      '';
    };
    usePersistence = mkOption {
      type = bool;
      default = osCfg.usePersistence;
      description = ''
        use persistence
      '';
    };
  };
}
