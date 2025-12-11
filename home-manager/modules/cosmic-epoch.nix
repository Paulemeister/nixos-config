{ pkgs, ... }:
{
  # services.ssh-agent.enable = true;
  # services.gnome-keyring = {
  #   enable = true;
  #   components = ["secrets" "pkcs11"];
  # };
  home.persistence."/persist/home/paulemeister".directories = [

    ".config/cosmic" # give up on cosmic-manager, as it has bugs when reloading home-manager -> dissapearing panels
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-cosmic
      xdg-desktop-portal
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-cosmic
      xdg-desktop-portal
    ];
  };
  systemd.user.services.hotcorner = {
    Unit = {
      Description = "Service for the hotcorner on cosmic-epoch";
      After = [ "graphical-session-post.target" ];
      BindsTo = [ "cosmic-session.target" ];
    };
    Service = {
      # ExecCondition = "${pkgs.procps}/bin/pgrep -xf cosmic-workspaces";
      ExecStart = "${pkgs.waycorner}/bin/waycorner";
      # ExecStart = "${pkgs.coreutils}/bin/env";
      ExecStartPre = "${pkgs.procps}/bin/pgrep -xf cosmic-workspaces";
      Restart = "on-failure";
      RestartSec = 2;
      # Type = "oneshot";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.configFile."waycorner/config.toml".text = ''
    [main-monitor]
    enter_command = [  "${pkgs.cosmic-workspaces-epoch}/bin/cosmic-workspaces" ]
    # enter_command = [  "${pkgs.firefox}/bin/firefox" ]
    locations = [ "top_left"]  # default
    size = 10  # default
    margin = 20  # default
    timeout_ms = 0  # default
    color = "#FFFF0000"  # default
  '';
}
