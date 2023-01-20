{pkgs}:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
    fetchFromGitLab = args@{domain, owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitLab { inherit domain owner repo rev sha256; } // args;
in rec {
        source = fetchFromGitLab rec {
                version = "8.0-rc4";
                sha256 = "sha256-KpmuvjOHccQWRs7z7Nxp6gX2+ZF74rdeuWjiLmtOC8g=";
                domain = "gitlab.collabora.com";
                owner = "alf";
                repo = "wine";
                rev = "0a941afbe6a06009b0859f745e505b51466c51fa";

                gecko32 = fetchurl rec {
                        version = "2.47.3";
                        url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
                        sha256 = "sha256-5bmwbTzjVWRqjS5y4ETjfh4MjRhGTrGYWtzRh6f0jgE=";
                };
                gecko64 = fetchurl rec {
                        version = "2.47.3";
                        url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
                        sha256 = "sha256-pT7pVDkrbR/j1oVF9uTiqXr7yNyLA6i0QzSVRc4TlnU=";
                };

                mono = fetchurl rec {
                        version = "7.3.0";
                        url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
                        sha256 = "sha256-k54vVmlyDQ0Px+MFQmYioRozt644XE1+WB4p6iZOIv8=";
                };
        };
}
