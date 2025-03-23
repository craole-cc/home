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
      homeManagerModules.default = ./home;
      # flake = {
      #   homeConfigurations.craole = let
      #     inherit (inputs) nixpkgs home-manager;
      #     system = "x86_64-linux"; #TODO: This is counterintuitive. I don't want to declare a system here, because it should work on all systems
      #     pkgs = nixpkgs.legacyPackages."${system}";
      #     args = {
      #       #TODO: how can i get _modules.args here or passed into home-manager?
      #       fmt = self.perSystem.${system}._module.args.fmt;
      #     };
      #     paths = {
      #       store = ./.;
      #       local = "$HOME/Projects/admin";
      #       modules = ./home;
      #     };
      #   in
      #     home-manager.lib.homeManagerConfiguration {
      #       inherit pkgs;
      #       modules = [paths.modules];
      #       extraSpecialArgs = {
      #         inherit
      #           inputs
      #           args
      #           paths
      #           ;
      #       };
      #     };
      # };
      homeManager = {
        extraSpecialArgs = {
          inherit inputs;
          # You can define paths here
          paths = {
            store = ./.;
            local = "$HOME/Projects/admin";
            modules = ./home;
          };
        };

        users = {
          # This will be built for all systems in your systems list
          craole = {
            imports = [./home];
          };
        };
      };
    };
}
