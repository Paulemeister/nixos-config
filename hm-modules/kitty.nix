{
  lib,
  config,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.kitty.enable {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        map ctrl+[ send_text all \x1b
        confirm_os_window_close -2
        hide_window_decorations yes
      '';
      shellIntegration.mode = "disabled";
    };
  };
  options.pm-modules.kitty.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      kitty
    '';
  };
}
