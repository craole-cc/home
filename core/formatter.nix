{pkgs}: let
  fmtree = pkgs.nixfmt-tree.override {
    settings = {
      # The default is warn, which would be too annoying for people who just care about Nix
      on-unmatched = "info";
      # Assumes the user is using Git, fails if it's not
      tree-root-file = ".git/index";

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
    runtimePackages = with pkgs; [
      deadnix
      nixfmt-rfc-style
      alejandra
    ];
  };
in {
  home.packages = [fmtree];
}
