{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nixd
    nil
    # nixfmt-tree
    # nixfmt-rfc-style
  ];
}
