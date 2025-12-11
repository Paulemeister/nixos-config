{
  lib,
  ...
}:
{
  services.urserver.enable = true;
  # don't enable service by default
  systemd.user.services.urserver.wantedBy = lib.mkForce [ ];

}
