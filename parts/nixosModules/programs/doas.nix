{
  flake.nixosModules.doas = {
    security = {
      #protectKernelImage = lib.mkDefault true;
      sudo.enable = false;
      # Real sudo (not a doas shim): nh's remote deploy runs `sudo --non-interactive`,
      # which doas can't parse.
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
      doas = {
        enable = true;
        wheelNeedsPassword = false;
        extraRules = [
          {
            groups = ["wheel"];
            persist = true;
          }
          {
            users = ["polar"];
            noPass = true;
            runAs = "root";
          }
        ];
      };
    };
  };
}
