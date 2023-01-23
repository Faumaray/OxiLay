{
  pkgs,
  pkgsi686Linux,
  inputs,
  moltenvk,
}: {
  wine_wayland = pkgs.fetchFromGitLab {
    version = "8.0-rc4";
    sha256 = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
    domain = "gitlab.collabora.com";
    owner = "alf";
    repo = "wine";
    rev = "0a941afbe6a06009b0859f745e505b51466c51fa";
  };
  vkd3d = pkgs.callPackage "${inputs.nixpkgs}/pkgs/applications/emulators/wine/vkd3d.nix" {inherit moltenvk;};
  vkd3d_i686 = pkgsi686Linux.callPackage "${inputs.nixpkgs}/pkgs/applications/emulators/wine/vkd3d.nix" {inherit moltenvk;};
}
