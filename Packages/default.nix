{
  inputs,
  pkgs,
}: let
  packages = rec {
    webcord = pkgs.callPackage ./webcord {};
    pob-community = pkgs.callPackage ./pathOfBuilding {};
    glsl-language-server = pkgs.callPackage ./glslls {};
    glfw-minecraft-wayland = pkgs.callPackage ./glfw/glfw-minecraft-wayland.nix {};
    default = pkgs.callPackage ./webcord {};
  };
in
  packages
