{
  pkgs,
  ...
}:
{
  hardware.xpadneo.enable = true;
  # Setup for Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
