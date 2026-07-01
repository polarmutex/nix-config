{
  flake.maidModules.claude-dailylog = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.claude-dailylog = {
      claudePackage = lib.mkOption {
        type = lib.types.package;
        description = "Claude-code package or wrapper to run in the dailylog session";
      };
      claudeBinName = lib.mkOption {
        type = lib.types.str;
        default = "claude";
        description = "Binary name within claudePackage";
      };
      herdrPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "If non-null, use herdr for session management instead of zellij";
      };
      zellijPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.unstable.zellij;
        description = "Zellij package";
      };
      sessionName = lib.mkOption {
        type = lib.types.str;
        default = "claude-dailylog-session";
        description = "Zellij session name (not used with herdr)";
      };
      agentName = lib.mkOption {
        type = lib.types.str;
        default = "claude-morgen";
        description = "Herdr agent name used as target for send commands";
      };
      workspaceLabel = lib.mkOption {
        type = lib.types.str;
        default = "ideaverse";
        description = "Herdr workspace label to create the agent tab in";
      };
      claudeArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Extra arguments passed to the claude binary";
        example = ["--dangerously-skip-permissions"];
      };
      workingDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/polar/repos/personal/ideaverse";
      };
      morgenApiTokenPath = lib.mkOption {
        type = lib.types.str;
        description = "Path to the morgen API token secret file";
      };
      dailyPrompt = lib.mkOption {
        type = lib.types.str;
        default = ''read @me.md , @"aios/maps/Vault Map.md" , and @"aios/maps/Skill Map.md" and run the daily brief'';
      };
      promptTime = lib.mkOption {
        type = lib.types.str;
        default = "*-*-* 06:00:00";
        description = "OnCalendar expression for the daily prompt timer";
      };
    };

    config = let
      cfg = config.claude-dailylog;
      # useHerdr = cfg.herdrPackage != null;
      claudeBin = "${cfg.claudePackage}/bin/${cfg.claudeBinName}";
      claudeCmd = lib.concatStringsSep " " ([claudeBin] ++ cfg.claudeArgs);
      morgenEnv = ''
        if [ -r ${cfg.morgenApiTokenPath} ]; then
          export MORGEN_API_KEY=$(${pkgs.coreutils}/bin/cat ${cfg.morgenApiTokenPath})
        fi
      '';
    in {
      systemd.services.claude-dailylog =
        # if useHerdr
        # then let
        let
          startScript = pkgs.writeShellScript "herdr-claude-dailylog-start" ''
            ${morgenEnv}
            HERDR="${cfg.herdrPackage}/bin/herdr"
            EXISTING_TAB=$($HERDR agent get ${cfg.agentName} 2>/dev/null \
              | ${pkgs.jq}/bin/jq -r '.result.agent.tab_id // empty' 2>/dev/null || true)
            if [ -n "$EXISTING_TAB" ]; then
              $HERDR tab close "$EXISTING_TAB" 2>/dev/null || true
            fi
            WORKSPACE_ID=$($HERDR workspace list \
              | ${pkgs.jq}/bin/jq -r '.result.workspaces[] | select(.label == "${cfg.workspaceLabel}") | .workspace_id')
            TAB_ID=$($HERDR tab create --label ${cfg.agentName} --workspace "$WORKSPACE_ID" \
              | ${pkgs.jq}/bin/jq -r '.result.tab.tab_id')
            $HERDR agent start ${cfg.agentName} \
              --cwd ${cfg.workingDirectory} \
              --tab "$TAB_ID" \
              --no-focus \
              -- ${claudeCmd}
          '';
        in {
          description = "Herdr claude dailylog agent (${cfg.agentName})";
          wantedBy = ["default.target"];
          after = ["network-online.target"];
          environment = {
            TERM = "xterm-256color";
            SHELL = "${pkgs.bashInteractive}/bin/bash";
          };
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
            WorkingDirectory = cfg.workingDirectory;
            ExecStart = startScript;
          };
        };
      # else let
      #   layout = pkgs.writeText "claude-dailylog-layout.kdl" ''
      #     layout {
      #       pane name="${cfg.agentName}" command="${claudeBin}" {}
      #     }
      #   '';
      #   startScript = pkgs.writeShellScript "zellij-claude-dailylog-start" ''
      #     ${morgenEnv}
      #     ZELLIJ="${cfg.zellijPackage}/bin/zellij"
      #     $ZELLIJ delete-session ${cfg.sessionName} --force 2>/dev/null || true
      #     $ZELLIJ --layout ${layout} attach --create-background ${cfg.sessionName}
      #   '';
      #   stopScript = pkgs.writeShellScript "zellij-claude-dailylog-stop" ''
      #     ${cfg.zellijPackage}/bin/zellij delete-session ${cfg.sessionName} --force 2>/dev/null || true
      #   '';
      # in {
      #   description = "Persistent zellij claude dailylog session (${cfg.sessionName})";
      #   wantedBy = ["default.target"];
      #   environment = {
      #     TERM = "xterm-256color";
      #     SHELL = "${pkgs.bashInteractive}/bin/bash";
      #   };
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = "yes";
      #     WorkingDirectory = cfg.workingDirectory;
      #     ExecStart = startScript;
      #     ExecStop = stopScript;
      #   };
      # };

      systemd.services.claude-dailylog-prompt = let
        promptScript =
          # if useHerdr
          # then
          pkgs.writeShellScript "herdr-claude-dailylog-prompt" ''
            HERDR="${cfg.herdrPackage}/bin/herdr"
            PANE_ID=$($HERDR agent get ${cfg.agentName} | ${pkgs.jq}/bin/jq -r '.result.agent.pane_id')
            $HERDR pane run "$PANE_ID" "/clear"
            sleep 1
            $HERDR pane run "$PANE_ID" "${cfg.dailyPrompt}"
          '';
        # else
        #   pkgs.writeShellScript "zellij-claude-dailylog-prompt" ''
        #     ZELLIJ="${cfg.zellijPackage}/bin/zellij"
        #     PANE_ID=$($ZELLIJ --session ${cfg.sessionName} action list-panes | ${pkgs.gawk}/bin/awk 'NR>1 && $2=="terminal" {print $1; exit}')
        #     $ZELLIJ --session ${cfg.sessionName} action write-chars --pane-id "$PANE_ID" "/clear"
        #     $ZELLIJ --session ${cfg.sessionName} action send-keys --pane-id "$PANE_ID" "Enter"
        #     sleep 1
        #     $ZELLIJ --session ${cfg.sessionName} action write-chars --pane-id "$PANE_ID" "${cfg.dailyPrompt}"
        #     $ZELLIJ --session ${cfg.sessionName} action send-keys --pane-id "$PANE_ID" "Enter"
        #   '';
      in {
        description = "Send daily brief prompt to claude dailylog session";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = promptScript;
        };
      };

      systemd.timers.claude-dailylog-prompt = {
        description = "Daily prompt timer for claude dailylog";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = cfg.promptTime;
          Persistent = true;
        };
      };
    };
  };
}
