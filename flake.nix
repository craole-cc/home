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
  in {
    devShells.${system} = import ./core/dev.nix {inherit pkgs;};
    formatter.${system} = import ./core/fmt.nix {inherit pkgs;};
    homeConfigurations.${alpha} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./core
        ./packages
      ];
      extraSpecialArgs = {
        paths = {
          store = ./.;
          local = "$HOME/Projects/home";
        };
      };
    };
  };
}
