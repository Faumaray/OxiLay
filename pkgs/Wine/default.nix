{pkgs}:
(pkgs.wineWowPackages.waylandFull.overrideAttrs    (oldAttrs: {
        repo = "wine";
        rev = "0a941afbe6a06009b0859f745e505b51466c51fa";
        version = "8.0-rc4";
        hash = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
}))

