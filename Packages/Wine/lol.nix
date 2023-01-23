{
  pkgs,
  lib,
  callPackage,
}: (pkgs.wineWowPackages.waylandFull.overrideAttrs (oldAttrs: {
  src = lib.getAttr "source" (callPackage ./source.nix {}); # Due strange clone
  version = "8.0-rc4";
  patches = [
    ./league_of_legends_patches/0002-LoL-6.17+-syscall-fix.patch
    ./league_of_legends_patches/0003-LoL-abi.vsyscall32-alternative_patch_by_using_a_fake_cs_segment.patch
    ./league_of_legends_patches/0004-LoL-broken-client-update-fix.patch
    ./league_of_legends_patches/0005-LoL-client-slow-start-fix.patch
    ./league_of_legends_patches/0006-LoL-abi-vsyscall32-disable-vDSO.patch
  ];
}))
