{args, ...}: {
  home = let
    inherit (args.fmt) packages config;
  in {
    inherit packages;
    xdg.configFile."treefmt/config.toml".source = config;
  };
}
