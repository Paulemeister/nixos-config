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
  config = mkIf cfg.cli-tools.enable {
    home.packages = with pkgs; [
      nvtopPackages.amd
      sd
      killall
      fastfetch
      tlrc
      (writeShellApplication {
        name = "where";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          which "$1" | xargs realpath
        '';
      })
      inputs.pdfcat.packages.${pkgs.stdenv.hostPlatform.system}.unstable
    ];
    programs = {
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      yazi.enable = true;
      btop = {
        enable = true;
        settings = {
          vim_keys = false;
        };
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          add_newline = false;
          command_timeout = 1300;
          scan_timeout = 50;
          format = "$all";
          character = {
            success_symbol = "[](bold green) ";
            error_symbol = "[✗](bold red) ";
          };
        };
      };
      # don't forget you're using blesh in bash.initExtra !!
    };
  };
  options.pm-modules.cli-tools.enable = mkOption {
    type = bool;
    default = cfg.enableDefault;
    description = ''
      random cli tools
    '';
  };
}
