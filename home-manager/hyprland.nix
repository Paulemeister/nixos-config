{pkgs, ...}: {
  home.packages = with pkgs; [
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
      ];
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$browser" = "${pkgs.firefox}/bin/firefox";
      "$email" = "${pkgs.thunderbird}/bin/thunderbird";
      "$filemanager" = "${pkgs.nautilus}/bin/nautilus -w";
      "bind" = [
        "SUPER,T,exec,$terminal"
        "SUPER,B,exec,$browser"
        "SUPER,E,exec,$email"
        "SUPER,F,exec,$filemanager"
        "CTRL + ALT,Delete,exit"

        # Workspace switching (only vertical for now)
        "SUPER + CTRL,Up,exec,${pkgs.hyprnome}/bin/hyprnome -p"
        "SUPER + CTRL,Down,exec,${pkgs.hyprnome}/bin/hyprnome"
        "SUPER + CTRL + SHIFT,Up,exec,${pkgs.hyprnome}/bin/hyprnome -mp"
        "SUPER + CTRL + SHIFT,Down,exec,${pkgs.hyprnome}/bin/hyprnome -m"

        # Window management
        "SUPER,q,killactive"
      ];
      bindr = [
        "SUPER,SUPER_L,exec,pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
      ];
      animation = [
        "workspaces,1,5,default,slidevert"
      ];
    };
  };

  programs.wofi.enable = true;

  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+left_bracket" = "text:\x1b";
    };
    shellIntegration.mode = "disabled";
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-center = ["clock"];
        modules-right = ["network" "pulseaudio" "tray"];
      };
    };
  };
}
