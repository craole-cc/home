{
  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "Home Manager Development Environment";

      packages = with pkgs; [
        nixfmt-rfc-style
        alejandra
        nixd
        git
        gitui
        home-manager
      ];

      commands = [
        {
          name = "update";
          help = "Update flake inputs (Fly)";
          command = "nix flake update";
          category = "maintenance";
        }
        {
          name = "switch";
          help = "Switch to the new home-manager configuration (Flash)";
          command = "home-manager switch --flake .#craole@QBX";
          category = "maintenance";
        }
        {
          name = "clean";
          help = "Clean up old generations and garbage collect (Flush)";
          command = "nix-collect-garbage -d && home-manager expire-generations '-7 days'";
          category = "maintenance";
        }
        {
          name = "format";
          help = "Format nix files (Fmtree)";
          command = "alejandra .";
          category = "development";
        }
        {
          name = "rebuild-all";
          help = "Update, clean, and switch to new configuration (Flick)";
          command = "nix flake update && home-manager switch --flake .#craole@QBX && nix-collect-garbage -d";
          category = "maintenance";
        }
        {
          name = "edit";
          help = "Open the configuration in your editor (Flake)";
          command = "$EDITOR .";
          category = "development";
        }
      ];

      env = [
        {
          name = "HOME_FLAKE";
          eval = "$PWD";
        }
        {
          name = "EDITOR";
          eval = "code";
        }
      ];
    };
  };
}
