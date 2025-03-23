# {pkgs, ...}:
# pkgs.nixfmt-tree.override {
#   settings = {
#     on-unmatched = "info";
#     tree-root-file = ".git/index";
#     formatter = {
#       deadnix = {
#         command = "deadnix";
#         priority = 1;
#         includes = ["*.nix"];
#       };
#       # nixfmt = {
#       #   command = "nixfmt";
#       #   priority = 2;
#       #   includes = ["*.nix"];
#       # };
#       alejandra = {
#         command = "alejandra";
#         priority = 2;
#         includes = ["*.nix"];
#       };
#     };
#   };
#   runtimePackages = with pkgs; [
#     deadnix
#     nixfmt-rfc-style
#     alejandra
#   ];
# }
{
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      global.on-unmatched = "info";
      programs = {
        nixfmt.enable = true;
        # rustfmt = {
        #   enable = true;
        #   inherit (rustToolchain) package;
        # };
        shellcheck.enable = true;
        shfmt.enable = true;
        taplo.enable = true;
        yamlfmt.enable = true;
      };
      formatter = {
        deadnix = {
          command = "deadnix";
          priority = 1;
          includes = ["*.nix"];
        };
        # nixfmt = {
        #   command = "nixfmt";
        #   priority = 2;
        #   includes = ["*.nix"];
        # };
        alejandra = {
          command = "alejandra";
          priority = 2;
          includes = ["*.nix"];
        };
      };
    };
  };
}
