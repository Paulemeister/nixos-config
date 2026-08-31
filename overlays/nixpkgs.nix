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
  psst = prev.psst.overrideAttrs (
    oldAttrs: finalAttrs: {

      version = "0-unstable-2026-08-18";
      src = prev.fetchFromGitHub {
        owner = "jpochyla";
        repo = "psst";
        rev = "3c3621aa79f820c737dd899e7e359b1359292466";
        hash = "sha256-+Wh4dhlfF/hQhDoe/ixoYvA2yVlgUygEgMbeUgWVAG4=";
      };
      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        src = prev.fetchFromGitHub {
          owner = "jpochyla";
          repo = "psst";
          rev = "3c3621aa79f820c737dd899e7e359b1359292466";
          hash = "sha256-+Wh4dhlfF/hQhDoe/ixoYvA2yVlgUygEgMbeUgWVAG4=";
        };
        hash = "sha256-sJX5iMPXsKE9UmD+WOAYqWTTouSzmiDbZppPtMoGue8=";
      };
    }
  );
})
