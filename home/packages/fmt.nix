{fmt, ...}: {
  home = {
    inherit (fmt) packages;
    # packages=fmt.packages;
    xdg.configFile."treefmt/config.toml".source = fmt.config;
  };
}
