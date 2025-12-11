{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt
    nix-output-monitor
  ];
  programs = {
    nh = {
      enable = true;
      flake = "/home/paulemeister/Code/nixos-config";
    };
  };
}
