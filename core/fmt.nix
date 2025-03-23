{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    _module.args.fmt = {
      config = config.treefmt.build.configFile;
      wrapper = config.treefmt.build.wrapper;
      packages = with pkgs; [
        alejandra
        deadnix
        shfmt
        shellcheck
        mdsh
        taplo
        yamlfmt
        biome
        deno
      ];
    };
    formatter = config.treefmt.build.wrapper;
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        #| Nix
        alejandra = {
          enable = true;
          priority = 2;
        };
        deadnix = {
          enable = true;
          priority = 1;
        };

        #| Shellscript
        shellcheck = {
          enable = true;
          priority = 1;
        };
        shfmt = {
          enable = true;
          priority = 2;
        };

        #| Documentation & Configuration
        mdsh = {
          enable = true;
          priority = 1;
        };
        taplo = {
          enable = true;
          priority = 1;
        };
        yamlfmt = {
          enable = true;
          priority = 1;
        };

        #| Web & Fallback
        biome = {
          enable = true;
          priority = 1;
        };
        deno = {
          enable = true;
          priority = 2;
        };
      };
      settings = {
        global.on-unmatched = "info";
        formatter = let
          sh.includes = [
            "**/sh/**"
            "**/shellscript/**"
            "**/bash/**"
          ];
        in {
          shellcheck.includes = sh.includes;
          shfmt.includes = sh.includes;
        };
      };
    };
  };
}
