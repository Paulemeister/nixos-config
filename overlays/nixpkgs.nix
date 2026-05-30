(final: prev: {
  # openldap = prev.openldap.overrideAttrs (oldAttrs: {
  #   doCheck = false;
  # });
  papers = prev.papers.overrideAttrs (
    oldAttrs: finalAttrs: {
      version = "50.2";

      src = prev.fetchurl {
        url = "mirror://gnome/sources/papers/50/papers-50.2.tar.xz";
        hash = "sha256-rhvc8c1Hy1DJ2EdleEYH+Bxy3xfdbmrZM/6hQXPSufQ=";
      };
    }
  );
})
