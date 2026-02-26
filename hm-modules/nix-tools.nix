{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.nix-tools.enable {

    home.packages = with pkgs; [
      nixfmt
      nix-output-monitor
    ];
    programs = {
      nh = {
        enable = true;
        # FIXME: hardcoded for paulemeister
        flake = "/home/paulemeister/Code/nixos-config";
        package = pkgs.nh;
      };
    };
  };
  options.pm-modules.nix-tools.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      nixfmt,nom,nh
    '';
  };
}
