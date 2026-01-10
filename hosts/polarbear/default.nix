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
  inherit (config.flake) maidModules;
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
        inputs.nix-maid.nixosModules.default
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
                mode = "440";
                group = "wheel";
              };
              gh-mcp={
                  mode = "440";
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
        #inputs.hardware.nixosModules.common-cpu-intel-cpu-only
        # inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
        #inputs.hardware.nixosModules.common-gpu-intel-disable
        # nixosModules.nvidia
        nixosModules.ai
        nixosModules.desktop
        nixosModules.bluetooth
        nixosModules.fonts
        nixosModules.cosmic
        # nixosModules.gnome
        nixosModules.graphical
        nixosModules.nix
        nixosModules.docker
        nixosModules.trusted
        #nixosModules.vmware
        nixosModules.yubikey
        nixosModules.user-polar
        nixosModules.ollama
        nixosModules._1password
        nixosModules.zed
        {
          services.displayManager.autoLogin = {
            enable = true;
            user = "polar";
          };
          # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
          systemd.services."getty@tty1".enable = false;
          systemd.services."autovt@tty1".enable = false;
          environment.sessionVariables = {
            # Cpu friendly cargo build jobs
            CARGO_BUILD_JOBS = "10";

            JAVA_HOME = "${pkgs.openjdk17.home}";
            # Increase max memory sizes for gradle builds
            JAVA_OPTIONS = "-Xms1024m -Xmx4096m";
            # https://github.com/swaywm/sway/issues/595
            _JAVA_AWT_WM_NONREPARENTING = "1";
          };

          environment.systemPackages = with pkgs; let
            morgen-updated =
              morgen.overrideAttrs
              (_: rec {
                version = "3.6.16";
                src = fetchurl {
                  name = "morgen-${version}.deb";
                  url = "https://dl.todesktop.com/210203cqcj00tw1/versions/${version}/linux/deb";
                  hash = "sha256-j1iv37b7erKOgvKU7R9GaTRNtcQpS4n9Awnni4OLvus=";
                };
              });
          in [
            ansible
            unstable.anki-bin
            unstable.devpod
            unstable.devcontainer
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
            self'.packages.git-polar
            self'.packages.ghostty
            self'.packages.google-chrome
            self'.packages.brave
            pkgs.firefox
            nvtopPackages.nvidia
            nodejs
            uv
            unstable.android-studio
            vscode
            self'.packages.context7-mcp
            self'.packages.github-mcp
          ];

          users.users.polar = {
            maid = {
                imports =[maidModules.claude-code];
              file.home.".gitconfig".source = self'.packages.git-polar.gitconfig;
              systemd.services.obsidian-second-brain-sync = {
                path = [
                  pkgs.git
                  pkgs.coreutils
                  pkgs.openssh
                ];
                script = ''
                  GIT_SSH_COMMAND='ssh -i /home/polar/.ssh/id_ed25519 -o IdentitiesOnly=yes'
                  OBSIDIAN_PATH="/home/polar/repos/personal/obsidian-second-brain/main"
                  cd $OBSIDIAN_PATH
                  CHANGES_EXIST="$(git status - porcelain | wc -l)"
                  if [ "$CHANGES_EXIST" -eq 0 ]; then
                    exit 0
                  fi
                  git add .
                  git commit -q -m "Last Sync: $(${pkgs.coreutils}/bin/date +"%Y-%m-%d %H:%M:%S") on nixos"
                  git pull --rebase
                  git push -q
                '';
                wantedBy = ["graphical-session.target"];
              };

              systemd.timers.obsidian-second-brain-sync = {
                unitConfig = {Description = "Obsidian Second Brain Periodic Sync";};
                timerConfig = {
                  Unit = "obsidian-second-brain-sync.service";
                  OnCalendar = "*:0/30";
                };
                wants = ["timers.target"];
              };
            };
          };
        }
      ]
    ));
}
