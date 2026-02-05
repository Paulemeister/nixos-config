{
  ...
}:
{
  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/private/ollama";
      mode = "0700";
    }
    "/var/lib/private/open-webui"
  ];

  services.open-webui = {
    enable = true;
  };
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    # package = pkgs.ollama-rocm;
    rocmOverrideGfx = "10.3.0";
  };

}
