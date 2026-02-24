{
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    ;
  inherit (lib.types) bool;
in
{
  config = mkIf cfg.ai.enable (mkMerge [
    (mkIf cfg.usePersistence {
      environment.persistence."/persist".directories = [
        {
          directory = "/var/lib/private/ollama";
          mode = "0700";
        }
        "/var/lib/private/open-webui"
      ];
    })
    {
      services = {
        open-webui.enable = true;
        ollama = {
          enable = true;
        };
      };
    }
  ]);

  options.pm-modules.ai.enable = mkOption {
    type = bool;
    default = false;
    description = ''
      ollama and openwebui
    '';
  };
}
