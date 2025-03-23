{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nixd
    nil
    discord
    # nixfmt-tree
    # nixfmt-rfc-style
  ];
}
