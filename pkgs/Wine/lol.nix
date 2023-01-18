{pkgs, lib, callPackage}:
(pkgs.wineWowPackages.waylandFull.overrideAttrs (oldAttrs: {
        src = lib.getAttr "source" (callPackage ./source.nix {});       # Due strange clone
        version = "8.0-rc4";
        patches = [
        ./lol.patch
        ];
}))
