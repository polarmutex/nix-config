{
  config,
  inputs,
  lib,
  withSystem,
  mkNixos,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules;
  inherit (config.flake) homeModules;
  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        # inherit self;
        inherit inputs;
        inherit lib;
      };
    }
    # load common modules
    ({...}: {
      imports = [
        nixosModules.core
        nixosModules.doas
        nixosModules.nix
        nixosModules.openssh
      ];
    })
  ];
in {
  flake.nixosConfigurations.polarbear = withSystem system ({
    self',
    pkgs,
    ...
  }:
    mkNixos system (
      [
        {
          sops = {
            # This will add secrets.yml to the nix store
            # You can avoid this by adding a string to the full path instead, i.e.
            # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
            defaultSopsFile = ./secrets.yaml;
            age = {
              # This will automatically import SSH keys as age keys
              sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
              # This is using an age key that is expected to already be in the filesystem
              keyFile = "/var/lib/sops-nix/key.txt";
              # This will generate a new key if the key specified above does not exist
              generateKey = true;
            };
            # This is the actual specification of the secrets.
            # sops.secrets.example-key = {};
            # sops.secrets."myservice/my_subdir/my_secret" = {};
            secrets = {
              git_config_work = {
                mode = "444";
                group = "wheel";
              };
            };
          };
          # nix.settings.ssl-cert-file = "/root/work.crt";
          # security.pki.certificates = let
          #   secrets = builtins.trace "secrets:" (builtins.extraBuiltins.readSops ./eval-secrets.nix);
          # in [
          #   secrets.work-cert-1
          #   secrets.work-cert-2
          # ];
        }
      ]
      ++ defaultModules
      ++ [
        ./configuration.nix
        inputs.hardware.nixosModules.common-cpu-intel-cpu-only
        inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
        inputs.hardware.nixosModules.common-gpu-intel-disable
        nixosModules.nvidia
        {
          # The open source driver does not support Maxwell GPUs.
          hardware.nvidia = {
            open = false;
            # prime = {
            #   # Bus ID of the Intel GPU.
            #   intelBusId = lib.mkDefault "PCI:0:2:0";
            #
            #   # Bus ID of the NVIDIA GPU.
            #   nvidiaBusId = lib.mkDefault "PCI:1:0:0";
            # };
          };
        }
        nixosModules.desktop
        nixosModules.bluetooth
        nixosModules.fonts
        nixosModules.cosmic
        # nixosModules.gnome
        nixosModules.graphical
        nixosModules.nix
        nixosModules.docker
        nixosModules.trusted
        nixosModules.vmware
        nixosModules.yubikey
        nixosModules.user-polar
        nixosModules.ollama
        nixosModules._1password
        {
          services.displayManager.autoLogin = {
            enable = true;
            user = "polar";
          };
          # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
          systemd.services."getty@tty1".enable = false;
          systemd.services."autovt@tty1".enable = false;

          environment.systemPackages = with pkgs; let
            morgen-updated =
              morgen.overrideAttrs
              (_: rec {
                version = "3.6.13";
                src = fetchurl {
                  name = "morgen-${version}.deb";
                  url = "https://dl.todesktop.com/210203cqcj00tw1/versions/${version}/linux/deb";
                  hash = "sha256-a7IkEHRAwa7SnsPcK6psho6E+o1aOlQPPFHaDPrrXxw=";
                };
              });
          in [
            ansible
            unstable.anki-bin
            unstable.devpod
            flameshot
            unstable.gramps
            unstable.libreoffice-fresh
            netscanner
            nix-diff
            unstable.npins
            unstable.obsidian
            peek
            unstable.zoom-us
            inputs.deploy-rs.packages.${system}.deploy-rs
            inputs.neovim-flake.packages.${system}.neovim
            morgen-updated
            self'.packages.fish
            self'.packages.ghostty
            self'.packages.git
            self'.packages.google-chrome
            self'.packages.brave
          ];

          home-manager.sharedModules = [
            homeModules.pop-shell
            {
              # services.ollama = {
              #   enable = true;
              #   # acceleration = false;
              # };

              systemd.user.services.obsidian-second-brain-sync = {
                Unit = {Description = "Obsidian Second Brain Sync";};
                Service = {
                  CPUSchedulingPolicy = "idle";
                  IOSchedulingClass = "idle";
                  ExecStart = toString (
                    pkgs.writeShellScript "obsidian-second-brain-sync" ''
                      #!/usr/bin/env sh
                      OBSIDIAN_PATH="$HOME/repos/personal/obsidian-second-brain/main"
                      cd $OBSIDIAN_PATH
                      CHANGES_EXIST="$(${pkgs.git}/bin/git status - porcelain | ${pkgs.coreutils}/bin/wc -l)"
                      if [ "$CHANGES_EXIST" -eq 0 ]; then
                        exit 0
                      fi
                      ${pkgs.git}/bin/git add .
                      ${pkgs.git}/bin/git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S") on nixos"
                      ${pkgs.git}/bin/git pull --rebase
                      ${pkgs.git}/bin/git push -q
                    ''
                  );
                };
              };

              systemd.user.timers.obsidian-second-brain-sync = {
                Unit = {Description = "Obsidian Second Brain Periodic Sync";};
                Timer = {
                  Unit = "obsidian-second-brain-sync.service";
                  OnCalendar = "*:0/30";
                };
                Install = {WantedBy = ["timers.target"];};
              };
            }
          ];
        }
      ]
    ));
}
