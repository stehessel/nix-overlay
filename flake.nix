{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports = [
        flake-parts.flakeModules.easyOverlay
        inputs.pre-commit-hooks.flakeModule
      ];

      perSystem = {
        config,
        inputs',
        ...
      }: {
        devShells.default = config.pre-commit.devShell;

        packages = {
          neovim-nightly = inputs'.neovim-flake.packages.neovim;
        };

        pre-commit.settings.imports = [./nix/pre-commit.nix];

        overlayAttrs = config.packages;
      };
    };
}
