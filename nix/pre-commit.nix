{pkgs, ...}: {
  hooks = {
    # Editor
    editorconfig-checker.enable = true;
    tagref.enable = true;

    # GitHub actions
    actionlint.enable = true;

    # Misc
    prettier.enable = true;

    # Nix
    alejandra.enable = true;
    deadnix.enable = true;
    statix = {
      enable = true;
      settings.ignore = [".direnv"];
    };

    # Builtin pre-commit hooks
    check-merge-conflict.enable = true;
    detect-private-key.enable =  true;
  };

  package = pkgs.prek;
}
