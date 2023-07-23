{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  glslang,
  cli11,
  fmt,
  nlohmann_json,
}:
stdenv.mkDerivation rec {
  pname = "glsl-language-server";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "glsl-language-server";
    rev = "7a449a7b72abdc5af5ddb964702716b85f41aa47";
    sha256 = "UgQXxme0uySKYhhVMOO7+EZ4BL2s8nmq9QxC2SFQqRg=";
    fetchSubmodules = true;
  };

  buildInputs = [ nlohmann_json fmt glslang ];

  nativeBuildInputs = [ cmake ninja nlohmann_json cli11 fmt.dev glslang ];


  patches = [
    ./0001-Fix-CMakeLists.patch
  ];

  meta = with lib; {
    description = ''
      A language server implementation for GLSL
      '';
    homepage = "https://github.com/svenstaro/glsl-language-server";
    licencse = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.faumaray ];
  };
}

