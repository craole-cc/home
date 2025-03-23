{args, ...}: let
  inherit (args.fmt) packages config;
in {
  home = {
    inherit packages;
    shellAliases.fmtree = ''treefmt'';
  };
  xdg.configFile."treefmt/config.toml".source = config;
}
