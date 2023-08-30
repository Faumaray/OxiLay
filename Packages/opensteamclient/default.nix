{ 
  gccMultiStdenv, 
  lib, 
  fetchFromGitHub, 
  cmake, 
  extra-cmake-modules, 
  qtbase,
  qtwayland,
  qtwebengine,
  wrapQtAppsHook,
  libarchive,
  protobuf,
  qrencode,
  curl,
  nlohmann_json,
  openssl,
  git,
  pkg-config
}:

gccMultiStdenv.mkDerivation rec {
  version = "0.0.2-beta";
  pname = "opensteamclient";

  src = fetchFromGitHub {
    owner = "Rosentti";
    repo = "opensteamclient";
    rev = "5641a2ea2cd24ed822a9b66847047821ccf1ecbb";
    sha256 = "sha256-RbVUjKV85SSFPZL1Guwu3qnNVcXLBR1ED2U9k1ZCJ8E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config git wrapQtAppsHook ];

  buildInputs = [ qtbase qtwebengine qtwayland libarchive protobuf qrencode curl nlohmann_json openssl ];
  preConfigure = ''
      substituteInPlace CMakeLists.txt \
        --replace /usr/share/applications $out/share/applications
      substituteInPlace CMakeLists.txt \
        --replace /usr/share/icons/hicolor/scalable/apps $out/share/icons/hicolor/scalable/apps
      substituteInPlace package/opensteam.sh \
        --replace /usr/lib/opensteam/opensteam $out/lib/opensteam/opensteam
      substituteInPlace CMakeLists.txt \
        --replace lib/opensteam/updater_files/ lib/opensteam/
      patchShebangs package/opensteam.sh
  '';

  meta = with lib; {
    description = "Partially open-source alternative Steam Client for Linux. ";
    homepage = "https://github.com/Rosentti/opensteamclient";
    license = licenses.zlib;
    maintainers = with maintainers; [ faumaray ];
    platforms = platforms.linux;
  };
}
