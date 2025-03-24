{
  self,
  config,
  inputs,
  ...
}: let
  inherit (self) lib;
  inherit (inputs) home-manager;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists genAttrs removePrefix;
  inherit (lib.attrsets) attrNames;
  inherit (config.easy-hosts) hosts;
  inherit (config.flake) nixosConfigurations;
  alpha = "craole";

  mkHomeConfiguration = {
    host,
    pkgs,
    user ? alpha,
    extraModules ? [],
  }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = concatLists [
        [./${user}]
        (collectNixModulePaths "${self}/modules/home-manager")
        extraModules
      ];
      extraSpecialArgs = {
        hostname = host;
        username = user;
      };
    };
in {
  imports = [home-manager.flakeModules.home-manager];
  # flake.homeConfigurations =
  #   genAttrs (
  #     map (hostname: "${alpha}@${hostname}") (attrNames hosts)
  #   ) (
  #     hostname: let
  #       host = removePrefix "${alpha}@" hostname;
  #       pkgs = nixosConfigurations.${host}._module.args.pkgs;
  #     in
  #       mkHomeConfiguration {
  #         inherit host pkgs;
  #       }
  #   );
  flake = {
    homeConfigurations."${alpha}" = let
      # system = "x86_64-linux"; #TODO: This is counterintuitive. I don't want to declare a system here, because it should work on all systems
      # pkgs = nixpkgs.legacyPackages."${system}";
      args = {
        #TODO: how can i get _modules.args here or passed into home-manager?
        # fmt = config._module.args.fmt;
      };
      paths = {
        store = ./.;
        local = "$HOME/Projects/admin";
        modules = ./${alpha};
      };
    in
      home-manager.lib.homeManagerConfiguration {
        # inherit pkgs;
        modules = [paths.modules];
        extraSpecialArgs = {
          inherit
            inputs
            # args
            paths
            ;
        };
      };
  };
}
