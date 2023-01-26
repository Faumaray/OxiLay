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
    wine-wayland = wineBuilder "wine-wayland" "wayland-full" {};
    wine-lol-wayland = wineBuilder "wine-lol-wayland" "wayland-full" {};
    default = wineBuilder "wine-lol-wayland" "wayland-full" {};
  };
in
  packages
