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
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        flake-parts.flakeModules.easyOverlay
      ];

      perSystem = {
        inputs',
        system,
        config,
        pkgs,
        lib,
        ...
      }: {
        packages = let
          darwinPackages =
            if lib.hasSuffix "darwin" system
            then rec {
              liblpeg = import ./packages/liblpeg-darwin.nix {inherit pkgs;};
              neovim-nightly = import ./packages/neovim-nightly.nix {
                inherit (inputs'.neovim-flake.packages) neovim;
                inherit liblpeg lib;
              };
            }
            else {
              neovim-nightly = import ./packages/neovim-nightly.nix {
                inherit (inputs'.neovim-flake.packages) neovim;
                inherit lib;
              };
            };
        in
          {} // darwinPackages;

        overlayAttrs = config.packages;
      };

      flake = {
        overlay = inputs.self.overlays.default;
      };
    };
}
