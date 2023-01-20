{
  description = "My personal Overlay with binary cache repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = inputs @ {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    overlays.default = _: prev:
      import ./Packages {
        inherit inputs;
        pkgs = prev;
      };

    packages = forAllSystems (system:
      self.overlays.default null (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }));

    homeManagerModules.default = import ./HMModules self;

    formatter = self.lib.genSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
