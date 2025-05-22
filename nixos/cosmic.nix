{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux";
  used-pkgs = pkgs-unstable;
  #used-pkgs.cosmic-idler = pkgs-unstable.cosmic-idler;
in {
  imports = [
    #(import "${inputs.nixpkgs-unstable}/nixos/modules/services/desktop-managers/cosmic.nix" {
    #  inherit config lib;
    #  pkgs = used-pkgs;
    #})
    #(import "${inputs.nixpkgs-unstable}/nixos/modules/services/display-managers/cosmic-greeter.nix" {
    #  inherit config lib;
    #  pkgs = used-pkgs;
    #})
    inputs.nix-cosmic.nixosModules.default
  ];

  services.desktopManager.cosmic.enable = true;
}
