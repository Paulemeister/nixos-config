{ pkgs, inputs, ... }:
{
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
    inputs.pdfcat.packages.${pkgs.stdenv.hostPlatform.system}.default
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
}
