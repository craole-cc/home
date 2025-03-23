{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    nixpkgs,
    home-manager,
    systems,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system}; #TODO
    supportedSystems = nixpkgs.lib.genAttrs (import systems);
  in {
    devShells = supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      default = import ./core/dev.nix {inherit pkgs;};
    in {inherit default;});

    formatter = supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      system = import ./core/fmt.nix {inherit pkgs;};
    in {inherit system;});

    # devShells.${system} = import ./core/dev.nix {inherit pkgs;};
    # formatter.${system} = import ./core/fmt.nix {inherit pkgs;};
    homeConfigurations."craole" = home-manager.lib.homeManagerConfiguration {
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
