{ lib, stdenv, fetchurl, makeWrapper, xdg-utils, dpkg, xorg, alsa-lib
, at-spi2-atk, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence, mesa
, nspr, nss, pango, systemd, libappindicator-gtk3, libdbusmenu, writeScript
, pipewire, libxkbcommon, libGL, electron }:
stdenv.mkDerivation rec {
  pname = "webcord";
  version = "4.1.1";

  src = fetchurl {
    url =
      "https://github.com/SpacingBat3/WebCord/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "a+58qW0HSBe9EfhxVA5KVxgH/RRH4WZwUGVt25QQYi0=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = [ makeWrapper dpkg ];

  libPath = lib.makeLibraryPath [
    libcxx
    systemd
    libpulseaudio
    libdrm
    mesa
    stdenv.cc.cc
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libnotify
    libX11
    libXcomposite
    libuuid
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    nss
    libxcb
    pango
    libGL
    libXScrnSaver
    libappindicator-gtk3
    libdbusmenu
    libxkbcommon
    pipewire
  ] + ":${stdenv.cc.cc.lib}/lib64";

  installPhase = ''
    runHook preInstall
    # Unpack release
    dpkg --fsys-tarfile $src | tar --extract
    rm -rf usr/share/lintian

    # Create necessary folders
    mkdir -p $out/{bin,lib,share}

    # Move artifacts to out folder
    mv usr/bin/* $out/bin
    mv usr/share/* $out/share
    mv usr/lib/webcord/* $out/lib

    # Fix permisions
    chmod -R g-w $out

    # Delete generated binary file
    rm $out/bin/webcord

    # Make out own executable with local electron
    makeWrapper ${electron}/bin/electron $out/bin/webcord \
      --set NIXOS_OZONE_WL 1 \
      --set LD_LIBRARY_PATH "${libPath}:$out/lib" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "$out/lib/resources/app.asar --use-gl=desktop --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations"

    # Fix path in desktop file
    substituteInPlace $out/share/applications/webcord.desktop \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/ $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "A Discord and Fosscord electron-based client implemented without Discord API.";
    homepage = "https://github.com/SpacingBat3/WebCord";
    license = licenses.mit;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
