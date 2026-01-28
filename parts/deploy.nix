{
  inputs,
  self,
  ...
}: {
  flake = {
    deploy = {
      nodes = {
        polarvortex = {
          hostname = "polarvortex";
          profiles.system = {
            sshUser = "polar";
            # sudo = "doas -u";
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
          };
        };
        vm-intel = {
          hostname = "vm-dev";
          profiles.system = {
            sshUser = "polar";
            sudo = "doas -u";
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-intel;
          };
        };
      };
    };
  };
}
