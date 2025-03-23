{pkgs, ...}: let
  # Helper function to create menu commands with descriptions
  mkCommand = {
    name,
    help,
    command,
    category ? "general",
  }: {
    inherit name help command category;
  };

  # Define common commands
  commands = [
    (mkCommand {
      name = "update";
      help = "Update flake inputs";
      command = "nix flake update";
      category = "nix";
    })
    (mkCommand {
      name = "switch";
      help = "Switch to the new home-manager configuration";
      command = "home-manager switch -b BaC --flake .";
      category = "home-manager";
    })
    (mkCommand {
      name = "clean";
      help = "Clean up old generations and garbage collect";
      command = "home-manager expire-generations 1 && nix-collect-garbage --delete-old";
      category = "maintenance";
    })
    (mkCommand {
      name = "format";
      help = "Format nix files";
      command = "nix fmt";
      category = "development";
    })
    (mkCommand {
      name = "git-status";
      help = "Check git status with gitui";
      command = "gitui";
      category = "git";
    })
    (mkCommand {
      name = "rebuild-all";
      help = "Update, clean, and switch to new configuration";
      command = "nix flake update && home-manager switch -b BaC --flake .";
      category = "workflow";
    })
  ];

  # Create menu script
  menu = pkgs.writeShellScriptBin "menu" ''
    #!/usr/bin/env bash

    # ANSI color codes
    BOLD='\033[1m'
    RESET='\033[0m'
    BLUE='\033[34m'
    GREEN='\033[32m'
    YELLOW='\033[33m'

    # Print header
    echo -e "\n''${BOLD}Home Manager Configuration Menu''${RESET}\n"

    # Group commands by category
    echo -e "''${BLUE}Nix Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "nix"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${BLUE}Home Manager Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "home-manager"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${BLUE}Maintenance Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "maintenance"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${BLUE}Development Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "development"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${BLUE}Git Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "git"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${BLUE}Workflow Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (builtins.map (
        cmd:
          if cmd.category == "workflow"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands)}

    echo -e "\n''${YELLOW}To run a command, use: run <command-name>''${RESET}\n"
  '';

  # Create command runner script
  runner = pkgs.writeShellScriptBin "run" ''
    #!/usr/bin/env bash

    # Check if HOME_FLAKE is set
    if [ -z "$HOME_FLAKE" ]; then
      export HOME_FLAKE="$PWD"
    fi

    # Ensure we're in the flake directory
    case "$PWD" in
      "$HOME_FLAKE"/*)
        # Already in the flake directory or a subdirectory
        ;;
      *)
        pushd "$HOME_FLAKE" || exit 1
        trap 'popd' EXIT
        ;;
    esac

    # Command map
    case "$1" in
      ${builtins.concatStringsSep "\n    " (builtins.map (
        cmd: ''          ${cmd.name})
                    ${cmd.command}
                    ;;''
      )
      commands)}
      *)
        echo "Unknown command: $1"
        echo "Run 'menu' to see available commands"
        ;;
    esac
  '';

  # Define the development shell
  mkDevShell = {
    name ? "home-manager-env",
    packages ? [],
  }:
    pkgs.mkShell {
      inherit name;

      packages = with pkgs;
        [
          nixfmt-rfc-style
          nixd
          git
          gitui
          home-manager
          menu
          runner
        ]
        ++ packages;

      shellHook = ''
        export HOME_FLAKE="$PWD"
        echo "Welcome to Home Manager development environment!"
        echo "Type 'menu' to see available commands"
      '';
    };
in {
  # Export the development shell creator
  inherit mkDevShell;

  # Export default devShell for convenience
  default = mkDevShell {};
}
