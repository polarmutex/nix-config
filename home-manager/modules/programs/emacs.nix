_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.emacs;
in {
  config = lib.mkIf cfg.enable {
    programs.emacs = {
      init = {
        enable = true;
        packageQuickstart = false;
        recommendedGcSettings = true;
        usePackageVerbose = false;

        usePackage = {
          beancount = {
            enable = true;
            package = _epkgs: pkgs.mine.emacsPackages.beancount-mode;
            mode = [
              ''("\\.beancount\\'" . beancount-mode)''
            ];
            config = ''
              (add-hook 'beancount-mode-hook #'eglot-ensure)
            '';
          };
          eglot = {
            enable = true;
            config = ''
              (setq eglot-server-programs
               (beancount-mode
                       . ,(eglot-alternatives
                           '(("beancount-language-server" "--stdio")
                             ("~/repos/personal/beancount-language-server/master/target/release/beancount-language-server" "--stdio"))))
              )
            '';
          };
        };
      };
    };
  };
}
