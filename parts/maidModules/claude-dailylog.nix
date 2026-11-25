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
        default = "claude-daily-log";
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
      # morgenApiTokenPath = lib.mkOption {
      #   type = lib.types.str;
      #   description = "Path to the morgen API token secret file";
      # };
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
      # morgenEnv = ''
      #   if [ -r ${cfg.morgenApiTokenPath} ]; then
      #     export MORGEN_API_KEY=$(${pkgs.coreutils}/bin/cat ${cfg.morgenApiTokenPath})
      #   fi
      # '';
    in {
      systemd.services.claude-dailylog =
        # if useHerdr
        # then let
        let
          startScript = pkgs.writeShellScript "herdr-claude-dailylog-start" ''
            set -euo pipefail
            HERDR="${cfg.herdrPackage}/bin/herdr"
            JQ="${pkgs.jq}/bin/jq"
            # herdr-server is Type=simple, so its socket may not be up yet
            for _ in $(seq 1 30); do
              $HERDR workspace list >/dev/null 2>&1 && break
              sleep 1
            done
            EXISTING_TAB=$($HERDR agent get ${cfg.agentName} 2>/dev/null \
              | $JQ -r '.result.agent.tab_id // empty' 2>/dev/null || true)
            if [ -n "$EXISTING_TAB" ]; then
              $HERDR tab close "$EXISTING_TAB" 2>/dev/null || true
            fi
            WORKSPACE_ID=$($HERDR workspace list \
              | $JQ -r '.result.workspaces[] | select(.label == "${cfg.workspaceLabel}") | .workspace_id' | head -n1)
            if [ -z "$WORKSPACE_ID" ]; then
              WORKSPACE_ID=$($HERDR workspace create --label ${cfg.workspaceLabel} \
                --cwd ${cfg.workingDirectory} --no-focus \
                | $JQ -er '.result.workspace.workspace_id')
            fi
            PANE_ID=$($HERDR tab create --label ${cfg.agentName} --workspace "$WORKSPACE_ID" \
              --cwd ${cfg.workingDirectory} --no-focus \
              | $JQ -er '.result.root_pane.pane_id')
            # herdr >= 0.9 `agent start --kind claude` only launches the bare `claude`
            # executable, so run the wrapper in the pane and name the detected agent.
            $HERDR pane run "$PANE_ID" "${claudeCmd}"
            for _ in $(seq 1 60); do
              if $HERDR agent get "$PANE_ID" >/dev/null 2>&1; then
                $HERDR agent rename "$PANE_ID" ${cfg.agentName}
                exit 0
              fi
              sleep 1
            done
            echo "no agent detected in pane $PANE_ID after 60s" >&2
            exit 1
          '';
        in {
          description = "Herdr claude dailylog agent (${cfg.agentName})";
          wantedBy = ["default.target"];
          # wants, not requires: requires would restart this (and recreate the tab)
          # every time herdr-server restarts
          wants = ["herdr-server.service"];
          after = ["herdr-server.service"];
          environment = {
            TERM = "xterm-256color";
            SHELL = "${pkgs.bashInteractive}/bin/bash";
          };
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
            WorkingDirectory = cfg.workingDirectory;
            ExecStart = startScript;
            Restart = "on-failure";
            RestartSec = "10s";
          };
        };

      systemd.services.herdr-server = {
        description = "Headless herdr server";
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "simple";
          # Skip (not fail) when a herdr server is already running, e.g. one started
          # by attaching the TUI; ExecCondition exit 1 = skip.
          ExecCondition = pkgs.writeShellScript "herdr-server-not-running" ''
            ! ${cfg.herdrPackage}/bin/herdr status server | ${pkgs.gnugrep}/bin/grep -q '^status: running'
          '';
          ExecStart = "${cfg.herdrPackage}/bin/herdr server";
          ExecStop = "${cfg.herdrPackage}/bin/herdr server stop";
          Restart = "on-failure";
          RestartSec = "5s";
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
            set -euo pipefail
            HERDR="${cfg.herdrPackage}/bin/herdr"
            # claude-dailylog is RemainAfterExit, so "active" doesn't mean the agent is alive
            if ! $HERDR agent get ${cfg.agentName} >/dev/null 2>&1; then
              echo "agent ${cfg.agentName} not found; restarting claude-dailylog.service" >&2
              ${pkgs.systemd}/bin/systemctl --user restart claude-dailylog.service
            fi
            $HERDR agent prompt ${cfg.agentName} "/clear"
            sleep 1
            $HERDR agent wait ${cfg.agentName} --until idle --timeout 10000
            $HERDR agent prompt ${cfg.agentName} ${lib.escapeShellArg cfg.dailyPrompt}
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
