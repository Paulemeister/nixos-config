{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yabridge
    yabridgectl
  ];
}
