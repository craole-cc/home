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
        # home-manager.flakeModules.home-manager
        devshell.flakeModule
        treefmt-nix.flakeModule
        ./core
      ];
      systems = import inputs.systems;
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
      flake = {
        # Define homeConfigurations for all systems
        home-manager.lib.homeManagerConfiguration  = let
          paths = {
            store = ./.;
            local = "$HOME/Projects/admin";
            modules = ./home;
          };
          # Function to create a home configuration for a given system
          mkHomeConfig = system: let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            # Get the formatter for this system
            fmt = self.perSystem.${system}.formatter;
          in {
            craole = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [paths.modules];
              extraSpecialArgs = {
                inherit inputs paths;
                args = {
                  inherit fmt;
                };
              };
            };
          };
        in
          # Map over all systems to create homeConfigurations for each
          builtins.foldl' (
            acc: system:
              acc // builtins.mapAttrs (name: value: value) (mkHomeConfig system)
          ) {} (import inputs.systems);
      };
    };
}
