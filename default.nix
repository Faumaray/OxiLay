# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:
let 
  wineWaylandLatestPkg = (pkgs.wineWowPackages.waylandFull.overrideAttrs (oldAttrs: {
    repo = "wine";
    rev = "wayland";
    version = "8.0-rc4";
    hash = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
  }));
  wineLoLWaylandLatestPkg = (pkgs.wineWowPackages.waylandFull.overrideAttrs (oldAttrs: {
    repo = "wine";
    rev = "wayland";
    version = "8.0-rc4";
    hash = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
    patches = [
      ./lol.patch
    ];
  }));

in
{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  webcord = pkgs.callPackage ./pkgs/webcord { };
  pob-community = pkgs.callPackage ./pkgs/pathOfBuilding { };
  wineLoLWaylandLatest = pkgs.callPackage wineLoLWaylandLatestPkg { };
  wineWaylandLatest = pkgs.callPackage wineWaylandLatestPkg { };
  
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
