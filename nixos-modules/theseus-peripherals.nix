{
  inputs,
  ...
}:
{
  # Siderwinderd Setup
  nixpkgs.overlays = [
    inputs.sidewinderd.overlays.default
  ];
  services.sidewinderd = {
    enable = true;
    settings = {
      capture_delays = false;
    };
  };
  environment.persistence."/persist".directories = [
    "/var/lib/sidewinderd" # sidewinder configs
  ];
  # systemd.services.no-rgb = {
  #   description = "no-rgb";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.openrgb}/bin/openrgb --mode static --color 000000";
  #     Type = "oneshot";
  #   };
  #   wantedBy = ["multi-user.target"];
  # };

  programs.coolercontrol.enable = true;
}
