# Easy integration helper for Zed Advanced
# This file makes it simple to add Zed Advanced to your configuration

{ inputs, ... }:

{
  # Add this to your home-manager imports to get Zed Advanced
  imports = [
    # Enable wrapper-manager if not already enabled
    inputs.wrapper-manager.homeManagerModules.default
    
    # Import the zed-advanced module
    ./default.nix
  ];
  
  # Basic Zed Advanced setup with sensible defaults
  quickSetup = {
    programs.wrapper-manager.enable = true;
    
    programs.zed-advanced = {
      enable = true;
      # All other settings use sensible defaults
      # Customize as needed in your configuration
    };
  };
  
  # Advanced setup with beancount integration
  beancountSetup = { beancountLsp, journalFile }: {
    programs.wrapper-manager.enable = true;
    
    programs.zed-advanced = {
      enable = true;
      beancountLsp = beancountLsp;
      journalFile = journalFile;
      
      # Add beancount to bundled extensions
      bundledExtensions = [
        "rust" "nix" "python" "java" "toml" "dockerfile" 
        "docker-compose" "makefile" "git-firefly" "ruff" "prettier"
      ];
    };
  };
}

# Usage examples:
#
# 1. Quick setup (in your home.nix):
#    imports = [ ./modules/wrapper-manager/zed-advanced/integration.nix ];
#    
# 2. With beancount (in your home.nix):
#    let
#      zedIntegration = import ./modules/wrapper-manager/zed-advanced/integration.nix { inherit inputs; };
#    in {
#      imports = [ zedIntegration ];
#      programs.zed-advanced = zedIntegration.beancountSetup {
#        beancountLsp = inputs.beancount-language-server.packages.${pkgs.system}.default;
#        journalFile = "/path/to/your/journal.beancount";
#      };
#    }