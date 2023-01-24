{
  inputs,
  lib,
  build,
  pkgs,
  pkgsCross,
  pkgsi686Linux,
  callPackage,
  moltenvk,
  supportFlags,
  stdenv_32bit,
}: let
  sources = import ./sources.nix {inherit pkgs pkgsi686Linux inputs moltenvk;};
  defaults = let
    original_sources = (import "${inputs.nixpkgs}/pkgs/applications/emulators/wine/sources.nix" {inherit pkgs;}).unstable;
  in {
    inherit supportFlags moltenvk;
    patches = [];
    buildScript = "${inputs.nixpkgs}/pkgs/applications/emulators/wine/builder-wow.sh";
    configureFlags = ["--disable-tests"];
    geckos = with original_sources; [gecko32 gecko64];
    mingwGccs = with pkgsCross; [mingw32.buildPackages.gcc mingwW64.buildPackages.gcc];
    monos = with original_sources; [mono];
    pkgArches = [pkgs pkgsi686Linux];
    platforms = ["x86_64-linux"];
    stdenv = stdenv_32bit;
    vkd3dArches = lib.optionals supportFlags.vkd3dSupport [sources.vkd3d sources.vkd3d_i686];
  };
  pnameGen = n: n + lib.optionalString (lib.hasInfix "full" build) "-full";
in {
  wine-lol-wayland = let
    pname = pnameGen "wine-lol";
  in
    callPackage "${inputs.nixpkgs}/pkgs/applications/emulators/wine/base.nix" (defaults
      // {
        inherit pname;
        version = "8.0-rc4";
        src = sources.wine_wayland;
        patches = [
          ./league_of_legends_patches/0002-LoL-6.17+-syscall-fix.patch
          ./league_of_legends_patches/0003-LoL-abi.vsyscall32-alternative_patch_by_using_a_fake_cs_segment.patch
          ./league_of_legends_patches/0004-LoL-broken-client-update-fix.patch
          ./league_of_legends_patches/0005-LoL-client-slow-start-fix.patch
          ./league_of_legends_patches/0006-LoL-abi-vsyscall32-disable-vDSO.patch
        ];
        configureFlags = defaults.configureFlags ++ ["--with-vkd3d"];
      });

  wine-wayland = let
    pname = pnameGen "wine";
  in
    callPackage "${inputs.nixpkgs}/pkgs/applications/emulators/wine/base.nix" (defaults
      // {
        inherit pname;
        version = "8.0-rc4";
        src = sources.wine_wayland;
        configureFlags = defaults.configureFlags ++ ["--with-vkd3d"];
      });
}
