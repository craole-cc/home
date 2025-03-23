{pkgs}: let
  fmtree = pkgs.nixfmt-tree.override {
    settings = {
      on-unmatched = "info";
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
