{
  description = "My personal Overlay with binary cache repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = inputs @ {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      # Because of wine, maybe check later not sure if ever gonna use ARM
      # "aarch64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    overlays.default = _: prev:
      import ./Packages {
        inherit inputs;
        pkgs = prev;
      };

    legacyPackages = forAllSystems (system:
      self.overlays.default null (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }));
      
    defaultPackage.x86_64-linux = self.legacyPackages.wine-lol-wayland;

    homeManagerModules.default = import ./HMModules self;

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
