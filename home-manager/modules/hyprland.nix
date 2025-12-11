{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    waybar
    hyprcorners
    wiremix
    blueberry
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
      hyprbars
    ];
    settings = {
      exec-once = [
        "${pkgs.waybar}/bin/waybar &"
        "${pkgs.hyprcorners}/bin/hyprcorners &"
        "hyprctl dispatch workspace 100"
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

        "ALT,TAB,hyprexpo:expo, toggle"

        # Media Keys
        ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5 "
        ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5 "
        ",XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -m"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      bindr = [
        "SUPER,SUPER_L,exec,pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
      ];
      general = {
        resize_on_border = true;
        gaps_in = 2;
        gaps_out = 2;
      };
      animation = [
        "workspaces,1,5,default,slidevert"
      ];
      windowrule = [
        "float,class:firefox,initialTitle:Picture-in-Picture"
        "plugin:hyprbars:nobar,class:^(org\.gnome.*|firefox|steam)$"
      ];
      input = {
        kb_layout = "eu";
        numlock_by_default = true;
      };
      decoration = {
        rounding = 8;
        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
        };
      };
      plugin = {
        hyprexpo = {
          skip_empty = true;
          workspace_method = "center current";
        };
        hyprbars = {
          # enabled = true;
          bar_height = 20;
          bar_padding = 5;
          bar_title_enabled = false;
          bar_part_of_window = true;
          icon_on_hover = true;
          bar_precedence_over_border = true;
          bar_color = "rgb(${config.lib.stylix.colors.base00-hex})";
          on_double_click = "hyprctl dispatch fullscreen 1";
          hyprbars-button = [
            "rgb(${config.lib.stylix.colors.base08-hex}), 10, 󰖭, hyprctl dispatch killactive"
            # "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
          ];
        };
      };
      debug.disable_logs = false;
    };
  };

  programs.wofi.enable = true;

  programs.kitty = {
    enable = true;
    extraConfig = ''
      map ctrl+[ send_text all \x1b
      confirm_os_window_close -2
    '';
    shellIntegration.mode = "disabled";
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "wireplumber"
        ];

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂯";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "${pkgs.blueberry}/bin/blueberry";
        };
        network = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click =
            with pkgs;
            "${kitty}/bin/kitty -e bash -c '${networkmanager}/bin/nmcli | ${less}/bin/less'";
        };
        wireplumber = {
          # Changed from "pulseaudio"
          "format" = "";
          format-muted = "󰝟";
          scroll-step = 5;
          on-click = "pavucontrol";
          tooltip-format = "Playing at {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Updated command
          max-volume = 150; # Optional: allow volume over 100%
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-size: 18px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }
    '';
    # style = ''
    #   @define-color bg #1d1f21;
    #   @define-color fg #c5c8c6;

    #   @define-color light-aqua #70c0ba;
    #   @define-color light-blue #81a2be;
    #   @define-color light-green #b5bd68;
    #   @define-color light-purple #b294bb;
    #   @define-color light-yellow #e6c547;
    #   @define-color light-orange #cc6666;

    #   * {
    #       font-family: 'SF Pro Text', sans-serif;
    #       font-weight: bold;
    #       font-size: 15px;
    #       border-radius: 50px;
    #   }

    #   window#waybar {
    #       background-color: transparent;
    #       color: @fg;
    #   }

    #   #workspaces button.active {
    #       background-color: @light-aqua;
    #       color: @bg;
    #   }

    #   #workspaces {
    #       background-color: @bg;
    #       margin-left: 6px;
    #   }

    #   .modules-left {
    #       margin-left: 12px;
    #   }

    #   .modules-right {
    #       margin-right: 12px;
    #   }

    #   #battery,
    #   #network,
    #   #pulseaudio,
    #   #backlight {
    #       color: @light-blue;
    #       background-color: @bg;
    #       margin: 0 6px 0 6px;
    #       padding: 0 15px 0 15px; /* top, right, bottom, left */
    #   }

    #   #clock {
    #       color: @light-green;
    #       background-color: @bg;
    #       margin: 0 6px 0 0;
    #       padding: 0 15px 0 15px;
    #   }

    #   #network {
    #       color: @light-purple;
    #   }

    #   #pulseaudio {
    #       color: @light-yellow;
    #   }

    #   #backlight {
    #       color: @light-orange;
    #   }

    # '';
  };
  stylix.targets.waybar.font = "sansSerif";

  # xdg.configFile."waycorner/config.toml".text = ''
  #   [top_left]
  #   enter_command = [ "${pkgs.hyprland}/bin/hyprctl", "dispatch hyprexpo:expo toggle" ]
  #   locations = [ "top_left" ]
  #   timeout_ms = 0
  #   size = 20
  #   [top_right]
  #   enter_command = [ "echo", "TEST" ]
  #   locations = [ "top_right" ]
  # '';
  xdg.configFile."hypr/hyprcorners.toml".text = ''
    timeout = 0
    screen_width = 1920
    screen_height = 1080

    [top_left]
    radius = 10
    dispatcher = "hyprexpo:expo"
    args = "toggle"
  '';
}
