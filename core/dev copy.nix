{pkgs, ...}: let
  mkCommand = {
    name,
    help,
    command,
    category ? "general",
  }: {
    inherit
      name
      help
      command
      category
      ;
  };

  name = "Home Manager Development Environment";

  msgs = {
    usage = "To run a command, use: run <command-name>";
    menu = "Run 'menu' to see available commands";
    cmdUnknown = "Unknown command";
    welcome = "Welcome to the ${name}!";
  };

  commands = [
    (mkCommand {
      name = "update";
      help = "Update flake inputs (Fly)";
      command = "Fly";
      category = "maintenance";
    })
    (mkCommand {
      name = "switch";
      help = "Switch to the new home-manager configuration (Flash)";
      command = "Flash";
      category = "maintenance";
    })
    (mkCommand {
      name = "clean";
      help = "Clean up old generations and garbage collect (Flush)";
      command = "Flush";
      category = "maintenance";
    })
    (mkCommand {
      name = "format";
      help = "Format nix files (Fmtree)";
      command = "Fmtree";
      category = "development";
    })
    (mkCommand {
      name = "rebuild-all";
      help = "Update, clean, and switch to new configuration (Flick)";
      command = "Flick";
      category = "maintenance";
    })
    (mkCommand {
      name = "edit";
      help = "Open the configuration in your editor (Flake)";
      command = "Flake";
      category = "development";
    })
  ];

  menu = pkgs.writeShellScriptBin "menu" ''
    #!/usr/bin/env bash

    # ANSI color codes
    BOLD='\033[1m'
    RESET='\033[0m'
    BLUE='\033[34m'
    GREEN='\033[32m'
    YELLOW='\033[33m'

    # Print header
    echo -e "\n''${BOLD}${name}''${RESET}\n"

    # Group commands by category
    echo -e "''${BLUE}Nix Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (
      builtins.map (
        cmd:
          if cmd.category == "nix"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands
    )}

    echo -e "\n''${BLUE}Home Manager Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (
      builtins.map (
        cmd:
          if cmd.category == "home-manager"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands
    )}

    echo -e "\n''${BLUE}Maintenance Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (
      builtins.map (
        cmd:
          if cmd.category == "maintenance"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands
    )}

    echo -e "\n''${BLUE}Development Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (
      builtins.map (
        cmd:
          if cmd.category == "development"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands
    )}

    echo -e "\n''${BLUE}Workflow Commands:''${RESET}"
    ${builtins.concatStringsSep "\n" (
      builtins.map (
        cmd:
          if cmd.category == "workflow"
          then ''echo -e "  ''${GREEN}${cmd.name}''${RESET} - ${cmd.help}"''
          else ""
      )
      commands
    )}

    echo -e "\n''${YELLOW}To run a command, use: run <command-name>''${RESET}\n"
  '';

  runner = with msgs;
    pkgs.writeShellScriptBin "run" ''
      #!/usr/bin/env bash

      # Command map
      case "$1" in
        ${builtins.concatStringsSep "\n    " (
        builtins.map (cmd: ''
          ${cmd.name})
                    ${cmd.command}
                    ;;'')
        commands
      )}
        *)
          printf %s: %s\n%s" "${cmdUnknown}" "$1" "${menu}"
          ;;
      esac
    '';
in
  pkgs.mkShell {
    inherit name;

    packages = with pkgs; [
      nixfmt-rfc-style
      alejandra
      nixd
      git
      gitui
      home-manager
      menu
      runner
    ];

    shellHook = ''
      export PATH="$PATH:${pkgs.writeShellScriptBin "Flux" "flux"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Fly" "fly"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Flash" "flash"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Flush" "flush"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Flick" "flick"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Flake" "flake"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Fmtree" "fmtree"}/bin"
      export PATH="$PATH:${pkgs.writeShellScriptBin "Fmt" "fmt"}/bin"

      if [ -z "$HOME_FLAKE" ]; then
        HOME_FLAKE="$PWD"
        export HOME_FLAKE
      fi

      printf "%s\n%s\n" "${msgs.welcome}" "${msgs.menu}"
    '';
  }
