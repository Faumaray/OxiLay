{
  default = import ../overlay.nix;
  wine = import ../pkgs/Wine/default.nix;
  # Add your overlays here
  #
  # my-overlay = import ./my-overlay;
}
