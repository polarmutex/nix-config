# Validation and testing tools for Zed Advanced wrapper
{ lib, pkgs, ... }:

{
  # Create validation script for testing the wrapper integration
  createValidationScript = { name ? "validate-zed-advanced" }: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ jq fd ripgrep coreutils ];
    
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      
      # Colors for output
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      BLUE='\033[0;34m'
      NC='\033[0m' # No Color
      
      # Logging functions
      log_info() {
        echo -e "''${BLUE}ℹ️  $1''${NC}"
      }
      
      log_success() {
        echo -e "''${GREEN}✅ $1''${NC}"
      }
      
      log_warning() {
        echo -e "''${YELLOW}⚠️  $1''${NC}"
      }
      
      log_error() {
        echo -e "''${RED}❌ $1''${NC}"
      }
      
      # Test configuration files
      validate_config() {
        log_info "Validating Zed configuration..."
        
        local config_home="''${XDG_CONFIG_HOME:-$HOME/.config}"
        local settings_file="$config_home/zed/settings.json"
        local keymap_file="$config_home/zed/keymap.json"
        local tasks_file="$config_home/zed/tasks.json"
        
        # Check if configuration files exist
        if [[ -f "$settings_file" ]]; then
          log_success "Settings file found: $settings_file"
          
          # Validate JSON syntax
          if jq empty "$settings_file" 2>/dev/null; then
            log_success "Settings JSON syntax is valid"
            
            # Check for key settings
            local theme=$(jq -r '.theme // "not-set"' "$settings_file")
            local vim_mode=$(jq -r '.vim_mode // false' "$settings_file")
            local auto_update=$(jq -r '.auto_update // true' "$settings_file")
            
            log_info "Theme: $theme"
            log_info "Vim mode: $vim_mode"
            log_info "Auto update: $auto_update"
            
            if [[ "$auto_update" == "false" ]]; then
              log_success "Auto-update is disabled (managed by Nix)"
            else
              log_warning "Auto-update is enabled (should be disabled for Nix management)"
            fi
          else
            log_error "Invalid JSON syntax in settings.json"
            return 1
          fi
        else
          log_error "Settings file not found: $settings_file"
          return 1
        fi
        
        # Check keymap file
        if [[ -f "$keymap_file" ]]; then
          log_success "Keymap file found: $keymap_file"
          
          if jq empty "$keymap_file" 2>/dev/null; then
            log_success "Keymap JSON syntax is valid"
            local bindings_count=$(jq '[.[].bindings | keys] | add | length' "$keymap_file" 2>/dev/null || echo "0")
            log_info "Custom key bindings: $bindings_count"
          else
            log_error "Invalid JSON syntax in keymap.json"
            return 1
          fi
        else
          log_warning "Keymap file not found (using defaults)"
        fi
        
        # Check tasks file
        if [[ -f "$tasks_file" ]]; then
          log_success "Tasks file found: $tasks_file"
          
          if jq empty "$tasks_file" 2>/dev/null; then
            log_success "Tasks JSON syntax is valid"
            local tasks_count=$(jq 'keys | length' "$tasks_file" 2>/dev/null || echo "0")
            log_info "Configured tasks: $tasks_count"
          else
            log_error "Invalid JSON syntax in tasks.json"
            return 1
          fi
        else
          log_info "No tasks file found (using defaults)"
        fi
      }
      
      # Test extensions bundle
      validate_extensions() {
        log_info "Validating extensions bundle..."
        
        local data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
        local extensions_dir="$data_home/extensions/installed"
        local index_file="$data_home/extensions/installed/index.json"
        
        if [[ -d "$extensions_dir" ]]; then
          log_success "Extensions directory found: $extensions_dir"
          
          # Count bundled extensions
          local ext_count=$(find "$extensions_dir" -maxdepth 1 -type d ! -name "installed" | wc -l)
          log_info "Bundled extensions: $ext_count"
          
          # Check index file
          if [[ -f "$index_file" ]]; then
            log_success "Extensions index found"
            
            if jq empty "$index_file" 2>/dev/null; then
              local indexed_count=$(jq '.bundled_count // 0' "$index_file")
              log_info "Indexed extensions: $indexed_count"
              
              if [[ "$ext_count" -eq "$indexed_count" ]]; then
                log_success "Extension count matches index"
              else
                log_warning "Extension count mismatch (found: $ext_count, indexed: $indexed_count)"
              fi
            else
              log_error "Invalid JSON syntax in extensions index"
            fi
          else
            log_warning "Extensions index not found"
          fi
          
          # List some extensions
          log_info "Available extensions:"
          find "$extensions_dir" -maxdepth 1 -type d ! -name "installed" -exec basename {} \; | head -5 | while read -r ext; do
            log_info "  - $ext"
          done
        else
          log_error "Extensions directory not found: $extensions_dir"
          return 1
        fi
      }
      
      # Test language servers in PATH
      validate_lsp_servers() {
        log_info "Validating language servers..."
        
        local lsp_servers=(
          "rust-analyzer"
          "pyright"
          "ruff"
          "clangd"
          "nixd"
          "nil"
          "typescript-language-server"
        )
        
        local found=0
        local total=''${#lsp_servers[@]}
        
        for lsp in "''${lsp_servers[@]}"; do
          if command -v "$lsp" >/dev/null 2>&1; then
            log_success "$lsp found in PATH"
            ((found++))
            
            # Try to get version if possible
            local version=""
            case "$lsp" in
              "rust-analyzer")
                version=$("$lsp" --version 2>/dev/null | head -1 || echo "unknown")
                ;;
              "pyright" | "typescript-language-server")
                version=$("$lsp" --version 2>/dev/null || echo "unknown")
                ;;
              "ruff")
                version=$("$lsp" --version 2>/dev/null || echo "unknown")
                ;;
              "clangd")
                version=$("$lsp" --version 2>/dev/null | head -1 || echo "unknown")
                ;;
              "nixd" | "nil")
                version=$("$lsp" --version 2>/dev/null || echo "unknown")
                ;;
            esac
            
            if [[ "$version" != "unknown" && -n "$version" ]]; then
              log_info "  Version: $version"
            fi
          else
            log_warning "$lsp not found in PATH"
          fi
        done
        
        log_info "Language servers available: $found/$total"
        
        if [[ $found -ge $((total * 3 / 4)) ]]; then
          log_success "Most language servers are available"
        else
          log_warning "Many language servers are missing"
        fi
      }
      
      # Test environment variables
      validate_environment() {
        log_info "Validating environment variables..."
        
        local required_vars=(
          "XDG_CONFIG_HOME"
          "XDG_DATA_HOME"
        )
        
        local optional_vars=(
          "ZED_BEANCOUNT_JOURNAL"
          "ZED_DISABLE_AUTO_UPDATE"
          "ZED_LOG"
        )
        
        # Check required variables
        for var in "''${required_vars[@]}"; do
          if [[ -n "''${!var:-}" ]]; then
            log_success "$var = ''${!var}"
          else
            log_error "$var not set"
            return 1
          fi
        done
        
        # Check optional variables
        for var in "''${optional_vars[@]}"; do
          if [[ -n "''${!var:-}" ]]; then
            log_info "$var = ''${!var}"
          else
            log_info "$var = not-set"
          fi
        done
      }
      
      # Test file associations
      validate_file_associations() {
        log_info "Validating file associations..."
        
        local config_home="''${XDG_CONFIG_HOME:-$HOME/.config}"
        local settings_file="$config_home/zed/settings.json"
        
        if [[ -f "$settings_file" ]]; then
          if jq -e '.file_types' "$settings_file" >/dev/null 2>&1; then
            log_success "File type associations configured"
            
            local associations=$(jq -r '.file_types | keys[]' "$settings_file" 2>/dev/null | wc -l)
            log_info "File type associations: $associations"
            
            # Show some associations
            log_info "Sample associations:"
            jq -r '.file_types | to_entries | .[:3] | .[] | "  \(.key): \(.value | join(", "))"' "$settings_file" 2>/dev/null || true
          else
            log_warning "No file type associations found in settings"
          fi
        fi
      }
      
      # Test Zed executable
      validate_zed_executable() {
        log_info "Testing Zed executable..."
        
        if command -v zed-advanced >/dev/null 2>&1; then
          log_success "zed-advanced command found"
          
          # Test version check
          if zed-advanced --version >/dev/null 2>&1; then
            local version=$(zed-advanced --version 2>/dev/null || echo "unknown")
            log_success "Zed version check passed: $version"
          else
            log_warning "Zed version check failed"
          fi
        else
          log_error "zed-advanced command not found in PATH"
          return 1
        fi
        
        # Check if zed alias exists
        if command -v zed >/dev/null 2>&1; then
          log_info "zed alias found"
        else
          log_warning "zed alias not found (may need shell restart)"
        fi
      }
      
      # Performance check
      validate_performance() {
        log_info "Running performance checks..."
        
        # Check configuration loading time
        local start_time=$(date +%s%N)
        
        # Simulate configuration loading by parsing JSON files
        local config_home="''${XDG_CONFIG_HOME:-$HOME/.config}"
        jq empty "$config_home/zed/settings.json" 2>/dev/null || true
        jq empty "$config_home/zed/keymap.json" 2>/dev/null || true
        
        local end_time=$(date +%s%N)
        local duration=$(( (end_time - start_time) / 1000000 ))  # Convert to milliseconds
        
        log_info "Configuration parsing time: ''${duration}ms"
        
        if [[ $duration -lt 100 ]]; then
          log_success "Configuration loading is fast"
        elif [[ $duration -lt 500 ]]; then
          log_info "Configuration loading is acceptable"
        else
          log_warning "Configuration loading might be slow"
        fi
      }
      
      # Main validation function
      main() {
        echo "🧪 Zed Advanced Wrapper Validation"
        echo "=================================="
        echo ""
        
        local exit_code=0
        
        # Run all validation tests
        validate_environment || exit_code=1
        echo ""
        
        validate_config || exit_code=1
        echo ""
        
        validate_extensions || exit_code=1
        echo ""
        
        validate_lsp_servers || exit_code=1
        echo ""
        
        validate_file_associations || exit_code=1
        echo ""
        
        validate_zed_executable || exit_code=1
        echo ""
        
        validate_performance || exit_code=1
        echo ""
        
        # Summary
        if [[ $exit_code -eq 0 ]]; then
          log_success "🎉 All validation checks passed!"
          echo ""
          log_info "Ready to use: zed-advanced /path/to/project"
          log_info "Or with alias: zed /path/to/project"
        else
          log_error "❌ Some validation checks failed"
          echo ""
          log_info "Check the errors above and ensure your configuration is correct"
          exit 1
        fi
      }
      
      # Run validation
      main "$@"
    '';
  };
  
  # Create a simple test script for development
  createTestScript = { name ? "test-zed-advanced" }: pkgs.writeShellScript name ''
    #!/usr/bin/env bash
    
    echo "🔧 Testing Zed Advanced Configuration..."
    
    # Quick tests
    echo "Configuration directory: $XDG_CONFIG_HOME"
    echo "Data directory: $XDG_DATA_HOME"
    echo "Beancount journal: ''${ZED_BEANCOUNT_JOURNAL:-not-set}"
    
    # Check if critical files exist
    if [[ -f "$XDG_CONFIG_HOME/zed/settings.json" ]]; then
      echo "✅ Settings file found"
    else
      echo "❌ Settings file missing"
    fi
    
    if [[ -d "$XDG_DATA_HOME/extensions/installed" ]]; then
      echo "✅ Extensions directory found"
    else
      echo "❌ Extensions directory missing"
    fi
    
    # Check a few language servers
    for lsp in rust-analyzer pyright ruff; do
      if command -v "$lsp" >/dev/null 2>&1; then
        echo "✅ $lsp available"
      else
        echo "⚠️  $lsp not available"
      fi
    done
    
    echo "🎉 Quick test completed!"
  '';
  
  # Create development helper script
  createDevScript = { name ? "zed-dev-helper" }: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ jq fd ripgrep ];
    
    text = ''
      #!/usr/bin/env bash
      
      cmd="''${1:-help}"
      
      case "$cmd" in
        "config")
          echo "📋 Current Zed Configuration:"
          echo "Config Home: $XDG_CONFIG_HOME"
          echo "Data Home: $XDG_DATA_HOME"
          echo ""
          echo "📁 Configuration Files:"
          find "$XDG_CONFIG_HOME/zed" -type f 2>/dev/null | head -10 || echo "No config files found"
          ;;
          
        "extensions")
          echo "📦 Bundled Extensions:"
          find "$XDG_DATA_HOME/extensions/installed" -maxdepth 1 -type d 2>/dev/null | grep -v "/installed$" | wc -l || echo "0"
          echo ""
          echo "📝 Extension List:"
          find "$XDG_DATA_HOME/extensions/installed" -maxdepth 1 -type d 2>/dev/null | grep -v "/installed$" | xargs -I {} basename {} | head -10 || echo "No extensions found"
          ;;
          
        "lsp")
          echo "🔧 Language Servers in PATH:"
          for lsp in rust-analyzer pyright ruff clangd nixd nil typescript-language-server; do
            if command -v "$lsp" >/dev/null 2>&1; then
              echo "✅ $lsp"
            else
              echo "❌ $lsp"
            fi
          done
          ;;
          
        "env")
          echo "🌍 Environment Variables:"
          echo "XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
          echo "XDG_DATA_HOME: $XDG_DATA_HOME"
          echo "ZED_BEANCOUNT_JOURNAL: ''${ZED_BEANCOUNT_JOURNAL:-not-set}"
          echo "ZED_DISABLE_AUTO_UPDATE: ''${ZED_DISABLE_AUTO_UPDATE:-not-set}"
          echo "ZED_LOG: ''${ZED_LOG:-not-set}"
          ;;
          
        "validate")
          validate-zed-advanced
          ;;
          
        "help"|*)
          echo "🛠️  Zed Development Helper"
          echo ""
          echo "Usage: $0 <command>"
          echo ""
          echo "Commands:"
          echo "  config      Show configuration status"
          echo "  extensions  List bundled extensions"
          echo "  lsp         Check language server availability"
          echo "  env         Show environment variables"
          echo "  validate    Run full validation suite"
          echo "  help        Show this help"
          ;;
      esac
    '';
  };
}