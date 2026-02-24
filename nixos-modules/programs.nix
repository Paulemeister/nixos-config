{
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.defaultPrograms.enable {

    programs.firefox.enable = true;

    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };

    # Open port for packet (quick share), lan-mouse
    networking.firewall = {
      allowedTCPPorts = [
        9300 # Quick Share
      ];
      allowedUDPPorts = [ 4242 ]; # Lan-Mouse
    };
  };

  options.pm-modules.defaultPrograms.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      add random used programs needing system changes (firefox, ausweisapp) and several rules 
    '';
  };
}
