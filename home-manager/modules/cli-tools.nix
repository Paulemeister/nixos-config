{ pkgs, ... }:
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
        # format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
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
