{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports = [
        flake-parts.flakeModules.easyOverlay
      ];

      perSystem = {
        config,
        inputs',
        ...
      }: {
        packages = {
          neovim-nightly = inputs'.neovim-flake.packages.neovim;
        };

        overlayAttrs = config.packages;
      };
    };
}
