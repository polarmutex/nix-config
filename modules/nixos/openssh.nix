{lib, ...}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = lib.mkDefault "no";

      # Enforce key-only authentication
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      PubkeyAuthentication = true;

      # Strict cryptographic algorithms
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group-exchange-sha256"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      # Connection and authentication limits
      LoginGraceTime = "30s";
      MaxAuthTries = 3;
      MaxStartups = "10:30:60";

      # Disable unnecessary features
      X11Forwarding = false;
      AllowTcpForwarding = "no";
      AllowStreamLocalForwarding = "no";
      GatewayPorts = "no";
      AllowAgentForwarding = false;

      # Only allow specific users
      AllowUsers = ["polar"];
    };
  };
  # programs.ssh = {
  #   startAgent = true;
  # };
}
# use 1pass for ssh keys
#Host *
#	IdentityAgent ~/.1password/agent.sock

