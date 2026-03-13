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
  config = mkIf cfg.phoneControl.enable {
    services.urserver.enable = true;
    # don't enable service by default
    systemd.user.services.urserver.wantedBy = lib.mkForce [ ];
    # kdeconnect
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };

  };

  options.pm-modules.phoneControl.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      add urserver for controlling pc by phone
    '';
  };

}
