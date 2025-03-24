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
  flake.homeConfigurations =
    genAttrs (
      map (hostname: "${alpha}@${hostname}") (attrNames hosts)
    ) (
      hostname: let
        host = removePrefix "${alpha}@" hostname;
        pkgs = nixosConfigurations.${host}._module.args.pkgs;
      in
        mkHomeConfiguration {
          inherit host pkgs;
        }
    );
}
