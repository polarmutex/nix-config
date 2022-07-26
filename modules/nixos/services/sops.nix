{ _, ... }:
#let
#secret_files = import ./secretdata.nix { inherit lib; };
#secrets = [
#  "protonmail_pw"
#];
#genDefaultPerms = secret: {
#  ${secret} = {
#    mode = "0440";
#    owner = config.users.users.polar.name;
#    inherit (config.users.users.polar) group;
#  };
#};
#in
{
  config = {
    sops = {
      #gnupg.sshKeyPaths = [ ];
      defaultSopsFile = ../../../secrets/secrets.yaml;
      # This will generate a new key if the key specified above does not exist
      #age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      #secrets = ((lib.foldl' lib.mergeAttrs) { }) (builtins.map genDefaultPerms secrets);
    };
  };
}
