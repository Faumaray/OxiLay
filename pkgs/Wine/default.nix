{pkgs}:
(pkgs.wineWowPackages.waylandFull.overrideAttrs    (oldAttrs: {
        repo = "wine";
        rev = "wayland";
        version = "8.0-rc4";
        hash = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
}))

