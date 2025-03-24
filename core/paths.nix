{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  # inherit (lib.strings) toUpper;
  inherit
    (lib.types)
    # attrs
    attrsOf
    either
    str
    path
    ;

  dom = "dots";
  mod = "paths";
  # sub = "qbx";
  cfg = config.${dom}.${mod};
in {
  options.${dom}.${mod} = {
    base = mkOption {
      description = "Path to the dots repository.";
      default = "/home/craole/.dots";
      type = either str path;
    };
    bin = mkOption {
      description = "Path to the dots bin directory.";
      default = "${cfg.base}/Utilities/bin";
      type = either str path;
    };
    conf = mkOption {
      description = "Path to the dots configuration directory.";
      default = "${cfg.base}/Configuration";
      type = either str path;
    };
    doc = mkOption {
      description = "Path to the dots documentation.";
      default = "${cfg.base}/Documentation";
      type = either str path;
    };
    env = mkOption {
      description = "Path to the dots environment.";
      default = "${cfg.base}/Environment";
      type = either str path;
    };
    lib = mkOption {
      description = "Path to the dots lib directory.";
      default = "${cfg.base}/Utilities/lib";
      type = either str path;
    };
    mod = mkOption {
      description = "Path to the dots modules directory.";
      default = "${cfg.base}/Modules";
      type = either str path;
    };
    pass = mkOption {
      description = "Path to the password directory.";
      default = "/var/lib/dots/passwords";
      type = either str path;
    };
    nixos = mkOption {
      description = "Path to the nixos configuration.";
      default = rec {
        base = "${cfg.conf}/nixos";
        conf = "${base}/configurations";
        hosts = "${conf}/hosts";
        users = "${conf}/users";
      };
      type = attrsOf (either str path);
    };
  };

  # config.environment = {
  #   variables = {
  #     DOTS = cfg.dots;
  #     DOTS_BIN = cfg.dotsBin;
  #     DOTS_CFG = cfg.dotsCFG;
  #   };
  #   shellAliases = {
  #     qbx = ''cd ${cfg.base}'';
  #     dots = ''cd ${cfg.dots}'';
  #   };
  # };
}
