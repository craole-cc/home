{
  description = "Home Manager configuration";

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = with inputs; [
        home-manager.flakeModules.home-manager
        devshell.flakeModule
        treefmt-nix.flakeModule
        ./core
      ];
      systems = import inputs.systems;
      perSystem = {system, ...}: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues inputs.self.overlays;
        };
      };
      flake = {
        homeConfigurations.craole = let
          inherit (inputs) nixpkgs home-manager;
          # system = "x86_64-linux"; #TODO: This is counterintuitive. I don't want to declare a system here, because it should work on all systems
          # pkgs = nixpkgs.legacyPackages."${system}";
          args = {
            #TODO: how can i get _modules.args here or passed into home-manager?
            # fmt = config._module.args.fmt;
          };
          paths = {
            store = ./.;
            local = "$HOME/Projects/admin";
            modules = ./home;
          };
        in
          home-manager.lib.homeManagerConfiguration {
            # inherit pkgs;
            modules = [paths.modules];
            extraSpecialArgs = {
              inherit
                inputs
                args
                paths
                ;
            };
          };
      };
    };

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      type = "github";
      owner = "numtide";
      repo = "devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
