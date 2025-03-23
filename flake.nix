{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = with inputs; [
        # home-manager.flakeModules.home-manager
        devshell.flakeModule
        treefmt-nix.flakeModule
        ./core
      ];
      systems = import inputs.systems;
      flake = {
        homeConfigurations = let
          inherit (inputs) nixpkgs home-manager;
        in {
          "craole@QBX" = let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages."${system}";
          in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [./home];
              extraSpecialArgs = {
                inherit inputs;
                paths = {
                  store = ./.;
                  local = "$HOME/Projects/admin";
                };
              };
            };
        };
      };
    };
}
