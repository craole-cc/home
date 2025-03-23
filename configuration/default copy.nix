{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "24.11";
    username = "craole";
    homeDirectory = "/home/craole";
    packages = [];
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };
  programs.home-manager.enable = true;
}
