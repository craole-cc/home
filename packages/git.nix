{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      userName = "craole-cc";
      userEmail = "134658831+craole-cc@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    gitui = {
      enable = true;
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        aliases = {
          "as" = "auth status";
        };
      };
      extensions = [pkgs.gh-eco];
    };
  };
}
