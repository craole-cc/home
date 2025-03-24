{ inputs, ... }:
{

  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {

      pre-commit = {
        check.enable = true;
        settings = {
          excludes = [ "^_sources/.*.nix$" ];

          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
              excludes = [
                # "modules"
                # "hosts"
                # "home"
              ];
            };

            alejandra = {
              enable = false;
            };

            convco = {
              enable = true;
            };

            statix = {
              enable = false;
              package = pkgs.statix;
              excludes = [
              ];
              # FIXME: https://github.com/cachix/git-hooks.nix/issues/288
              settings.ignore = [ "_sources*" ];
            };

            nixfmt-rfc-style = {
              enable = false;
              package = pkgs.nixfmt-rfc-style;
              excludes = [
                # "modules"
                # "hosts"
                # "home"
              ];
            };

            commitzen.enable = false;
            actionlint.enable = true;

            # basic commit checks
            check-added-large-files.enable = true;
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-shebang-scripts-are-executable.enable = false; # many of the scripts in the config aren't executable because they don't need to be.
            check-merge-conflicts.enable = true;
            detect-private-keys.enable = true;
            fix-byte-order-marker.enable = true;
            mixed-line-endings.enable = true;
            trim-trailing-whitespace.enable = true;
            end-of-file-fixer.enable = true;
          };
        };
      };
    };
}
