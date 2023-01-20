{pkgs ? import <nixpkgs> {}}: {
  webcord = pkgs.callPackage ./webcord {};
  pob-community = pkgs.callPackage ./pathOfBuilding {};
  wineWaylandLatest = pkgs.callPackage ./Wine/default.nix {};
  wineLoLWaylandLatest = pkgs.callPackage ./Wine/lol.nix {};
}
