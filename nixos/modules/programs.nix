{
  ...
}:
{

  programs.firefox.enable = true;

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  # Open port for packet (quick share), lan-mouse
  networking.firewall = {
    allowedTCPPorts = [
      9300 # Quick Share
    ];
    allowedUDPPorts = [ 4242 ]; # Lan-Mouse
  };
}
