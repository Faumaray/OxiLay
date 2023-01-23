{
  inputs,
  pkgs,
}: let
  inherit (pkgs) callPackage;
  wineBuilder = wine: build: extra:
    (import ./wine ({
        inherit inputs build pkgs;
        inherit (pkgs) callPackage lib moltenvk pkgsCross pkgsi686Linux stdenv_32bit;
        supportFlags = (import ./wine/supportFlags.nix).${build};
      }
      // extra))
    .${wine};

  packages = rec {
    webcord = pkgs.callPackage ./webcord {};
    pob-community = pkgs.callPackage ./pathOfBuilding {};
    wine-wayland = wineBuilder "wine-wayland" "full" {};
    wine-wayland-lol = wineBuilder "wine-wayland-lol" "full" {};
  };
in
  packages
