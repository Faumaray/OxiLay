{ 
  lib
, fetchFromGitHub
, fetchFromGitLab
, pkgconf
, stdenv
, fetchurl
, zlib
, qt5
, luajit
, libGL
, curl
, liberation_ttf
, ttf_bitstream_vera
, meson
, ninja
, unzip
, rsync
, dbus
, makeWrapper
, makeDesktopItem
}:
let
#https://github.com/PathOfBuildingCommunity/PathOfBuilding
    pathOfBuilding = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "HEAD";
      hash = "sha256-8RdEzoYVZ3pK4SJkOVTZ4RAMLl6UeMrQSN5Zy4EDE/E=";
    };
#https://gitlab.com/bcareil/pobfrontend.git#branch=luajit NO UPDATES
    pobFrontend = fetchFromGitLab {
      owner = "bcareil";
      repo = "pobfrontend";
      rev = "29feacd42e1f11274bad66514e6ad1a8d732ec21";
      sha256 = "4JKMyuTQEGqKTnai6h30FYyYvhiTnGRcNapB8cVrHxg=";
    };
#https://github.com/Lua-cURL/Lua-cURLv3
    luaCurl = fetchFromGitHub {
      owner = "Lua-cURL";
      repo = "Lua-cURLv3";
      rev = "9f8b6dba8b5ef1b26309a571ae75cda4034279e5";
      sha256 = "4IVYVb134yRQpKkHU7kgBXyhDIVW4iToTj1rTbLEBeA=";
    };
#https://github.com/Openarl/PathOfBuilding/files/1167199/PathOfBuilding-runtime-src.zip
    runtime = fetchurl {
      url = "https://github.com/Openarl/PathOfBuilding/files/1167199/PathOfBuilding-runtime-src.zip";
      sha256 = "08pnq89zy84k0j4pmj8ladp320n4ib1cmr8dnbmzmnrb5cm8f8bd";
    };
in
stdenv.mkDerivation rec {
  pname = "path-of-building-community";
  version = "2.25.1";

  doUnpack = false;
  doConfigure = false;
  doPatch = false;
 
  nativeBuildInputs = [ makeWrapper rsync stdenv unzip meson ninja luajit pkgconf qt5.qtbase qt5.qmake qt5.wrapQtAppsHook qt5.qtx11extras qt5.qtsvg qt5.qtwayland curl];
  dontWrapQtApps = true;
  unpackPhase = ''
    runHook preUnpack
    mkdir PathOfBuilding-runtime-src
    mkdir PathOfBuilding
    mkdir pobfrontend
    mkdir Lua-cURLv3
    unzip ${runtime}  -d PathOfBuilding-runtime-src
    cp -r ${pathOfBuilding}/* PathOfBuilding/
    cp -r ${pobFrontend}/* pobfrontend/
    cp -r ${luaCurl}/* Lua-cURLv3/
    cp ${luaCurl}/.config Lua-cURLv3/

    chmod -R +rw PathOfBuilding-runtime-src
    chmod -R +rw PathOfBuilding
    chmod -R +rw pobfrontend
    chmod -R +rw Lua-cURLv3

    runHook postUnpack
  '';

  patchPhase = ''
    runHook prePatch
    patch -d PathOfBuilding-runtime-src/LZip -p1 < ${./lzip-linux.patch}

    patch -d PathOfBuilding --no-backup-if-mismatch -p1 < ${./PathOfBuilding-force-disable-devmode.patch}

    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfigure

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd "PathOfBuilding-runtime-src/LZip" \
		&& $CXX -W -Wall -fPIC -shared -o lzip.so \
			-I"$(pkgconf luajit --variable=includedir)" \
			lzip.cpp \
			-L"$(pkgconf luajit --variable=libdir)" \
			-l"$(pkgconf luajit --variable=libname)" \
			-lz

		cd ../..
	# build lcurl.so
	cd "Lua-cURLv3" && make LUA_IMPL=luajit

	cd ..
	# build pobfrontend
	cd "pobfrontend" && meson -Dbuildtype=release build \
		&& cd build && ninja && strip ./pobfrontend && cd ../..

    runHook postBuild
  '';

  installPhase = ''
      runHook preInstal
      mkdir -p $out/{bin,opt,share}
      mkdir -p $out/share/pixmaps
      rsync -a '--exclude=.git*' "PathOfBuilding/" "$out/opt"

      install -s -m755 "PathOfBuilding-runtime-src/LZip/lzip.so" -t "$out/opt"
	    install -s -m755 "Lua-cURLv3/lcurl.so" -t "$out/opt"
	    install -s -m755 "pobfrontend/build/pobfrontend" -t "$out/opt"
	    install -D -m644 ${./PathOfBuilding-logo.svg} "$out/share/pixmaps/PathOfBuildingCommunity.svg"
	    install -D -m644 "${./PathOfBuilding-logo.png}" "$out/share/pixmaps/PathOfBuildingCommunity.png"

	    ln -sf $out/opt/pobfrontend $out/bin/PathOfBuildingCommunity

      wrapQtApp $out/bin/PathOfBuildingCommunity \
        --set LUA_PATH "$out/opt/runtime/lua/?.lua;$out/opt/runtime/lua/?/init.lua;$LUA_PATH" \
        --prefix PWD "$out/opt"

      cp -r ${makeDesktopItem {
          desktopName = "Path of Building (Community)";
          name = "PathOfBuildingCommunity";
          exec = "PathOfBuildingCommunity %U";
          icon = "PathOfBuildingCommunity";
          path = "@out@/opt";
      }}/* $out/

      substituteAllInPlace $out/share/applications/*

      runHook postInstall
  '';


  meta = with lib; {
    description = "An offline build planner for Path of Exile using PoBFrontend, LocalIdentity's fork";
    homepage = "https://github.com/PathOfBuildingCommunity/PathOfBuilding";
    license = licenses.mit;
    maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
