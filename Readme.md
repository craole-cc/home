# My Project

This project is a configuration setup using the Nix Flakes and Home Manager. It allows you to manage your home environment declaratively with Nix.

## Installation

To set up your environment using this configuration, you will need to have Nix installed on your system. Once you have Nix, follow these steps:

1. **Clone the Repository**:

   If the repository is public:

   ```sh
   HOME_FLAKE="$HOME/Projects/home"
   git clone https://github.com/craole-cc/home.git "${HOME_FLAKE}"
   cd "${HOME_FLAKE}"
   ```

   If the repository is private and you have GitHub CLI (gh) installed:

   ```sh
   HOME_FLAKE="$HOME/Projects/home"
   nix run nixpkgs#gh -- auth login
   nix run nixpkgs#gh -- repo clone craole-cc/home "${HOME_FLAKE}"
   cd "${HOME_FLAKE}"
   ```

2. **Run Home Manager**:
   Use the following command to apply the configuration:

   ```sh
   nix run home-manager -- switch --flake "${HOME_FLAKE}"
   ```

This command will activate the configuration defined in the flake, setting up your home environment according to the specifications provided.

## Usage

Once installed, you can customize your setup by editing the flake configuration files located within the repository. To apply changes, simply re-run the home-manager command

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or fixes.

## License

This project is licensed under the MIT License.
