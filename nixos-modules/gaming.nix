{
  pkgs,
  ...
}:
{
  hardware.xpadneo.enable = true;
  # Setup for Gaming
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        export MANGOHUD=1
      '';
    };
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
