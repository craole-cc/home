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
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."craole" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./core
        ./packages
      ];
    };
    formatter.${system} = import ./core/formatter.nix {inherit pkgs;};
  };
}
