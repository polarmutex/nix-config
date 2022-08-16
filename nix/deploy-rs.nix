{ self
, deploy-rs
, nixpkgs
, ...
}:
{
  #autoRollback = true;
  #magicRollback = true;
  #user = "root";
  #nodes = lib.mapAttrs genNode self.nixosConfigurations;
  nodes = {
    blackbear = {
      sshOpts = [ "-p" "22" ];
      hostname = "blackbear";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "polar";
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blackbear;
          user = "root";
        };
        #      #user = {
        #      #  sshUser = "polar";
        #      #  path =
        #      #    deploy-rs.lib.x86_64-linux.activate.home-manager self.homeManagerConfigurations.polar;
        #      #  user = "polar";
        #      #};
      };
    };
    #  polarvortex = {
    #    sshOpts = [ "-p" "22" ];
    #    hostname = "brianryall.xyz";
    #    fastConnection = false;
    #    profiles = {
    #      system = {
    #        sshUser = "polar";
    #        path =
    #          deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
    #        user = "root";
    #      };
    #    };
  };
}
