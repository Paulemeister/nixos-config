{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  imports = [ inputs.nix-index-database.homeModules.default ];
  config = mkIf cfg.nix-tools.enable {

    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true;

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
      nixfmt, nom, nh
    '';
  };
}
