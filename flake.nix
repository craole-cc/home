{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    alpha = "craole";
    pkgs = nixpkgs.legacyPackages.${system};
    fmtree = import ./core/formatter.nix {inherit pkgs;};
  in {
    homeConfigurations.${alpha} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./core
        ./packages
      ];
    };
    formatter.${system} = import ./core/formatter.nix {inherit pkgs;};
    # formatter.${system} = fmtree;
    # formatter.${system} = pkgs.nixfmt-tree;
  };
}
