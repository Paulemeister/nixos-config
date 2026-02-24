{
  config,
  lib,
  ...
}:
let
  cfg = config.pm-modules;
  inherit (lib) mkIf mkOption;
  inherit (lib.types) bool;
in
{

  config = mkIf cfg.dns.enable {
    networking = {
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      # If using NetworkManager:
      networkmanager.dns = "none";
    };

    services.dnscrypt-proxy = {
      enable = true;
      # Settings reference:
      # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        # Add this to test if dnscrypt-proxy is actually used to resolve DNS requests
        query_log.file = "/var/log/dnscrypt-proxy/query.log";
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = [
          # "cloudflare"
          "quad9-dnscrypt-ip4-nofilter-pri"
          "quad9-dnscrypt-ip6-nofilter-pri"
        ];
      };
    };
  };

  options.pm-modules.dns = {
    enable = mkOption {
      type = bool;
      default = cfg.enableDefault;
      description = ''
        use dnscrypt-proxy for dns
      '';
    };
  };
}
