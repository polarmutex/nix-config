{pkgs, ...}: {
  security = {
    #protectKernelImage = lib.mkDefault true;
    sudo.enable = false;
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
    wrappers.sudo = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.doas}/bin/doas";
    };
  };
}
