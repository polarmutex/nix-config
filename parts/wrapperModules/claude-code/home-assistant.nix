{config, ...}: {
  flake.wrappers.claude-code-home-assistant = {pkgs, ...}: {
    imports = [config.flake.wrapperModules.claude-code-polar];

    binName = "claude-home-assistant";
    # Read-only tools only; anything that changes state still prompts.
    settings.permissions.allow =
      map (t: "mcp__home-assistant__ha_${t}") [
        "get_overview" "get_state" "get_entity" "get_device" "get_history"
        "get_logs" "get_system_health" "get_integration" "get_automation_traces"
        "get_skill_guide" "get_zone" "get_todo" "get_operation_status"
        "get_hacs_info" "get_app" "get_camera_image" "search" "eval_template"
        "list_services" "list_floors_areas"
        "config_get_automation" "config_get_script" "config_get_scene"
        "config_get_dashboard" "config_get_label" "config_get_category"
        "config_get_calendar_events" "config_list_helpers" "config_list_groups"
        "config_list_dashboard_resources"
      ]
      # Tools unifi-network-mcp 0.27.1 annotates readOnlyHint (eager mode).
      ++ map (t: "mcp__unifi__unifi_${t}") [
        "tool_index" "batch_status" "list_acl_rules" "get_acl_rule_details"
        "list_client_groups" "get_client_group_details" "lookup_by_ip" "list_clients"
        "get_client_details" "list_blocked_clients" "list_content_filters"
        "get_content_filter_details" "list_devices" "get_device_details" "get_device_radio"
        "get_speedtest_status" "list_rogue_aps" "get_rf_scan_results" "list_available_channels"
        "get_pdu_outlets" "list_dns_records" "get_dns_record_details" "list_dpi_applications"
        "list_dpi_categories" "list_dynamic_dns" "get_dynamic_dns_entry_details" "list_events"
        "list_alarms" "recent_events" "subscribe_events" "get_event_types"
        "list_firewall_policies" "get_firewall_policy_details" "get_firewall_policy_ordering"
        "list_firewall_zones" "list_legacy_firewall_rules" "list_firewall_groups"
        "get_firewall_group_details" "get_gateway_settings" "list_vouchers"
        "get_voucher_details" "list_networks" "get_network_details" "list_wlans"
        "get_wlan_details" "list_ap_groups" "get_ap_group_details" "list_oon_policies"
        "get_oon_policy_details" "list_port_forwards" "get_port_forward" "list_qos_rules"
        "get_qos_rule_details" "list_routes" "list_active_routes" "get_route_details"
        "get_network_stats" "get_client_stats" "get_device_stats" "get_top_clients"
        "get_dpi_stats" "get_alerts" "get_gateway_stats" "get_speedtest_results"
        "get_site_dpi_traffic" "get_client_dpi_traffic" "get_ips_events" "get_client_sessions"
        "get_dashboard" "get_anomalies" "get_client_wifi_details" "list_port_profiles"
        "get_port_profile_details" "get_switch_ports" "get_port_stats" "get_lldp_neighbors"
        "get_switch_capabilities" "get_system_info" "get_network_health" "get_site_settings"
        "get_snmp_settings" "list_backups" "get_autobackup_settings" "get_traffic_flows"
        "get_traffic_flow_statistics" "list_traffic_routes" "get_traffic_route_details"
        "list_usergroups" "get_usergroup_details" "list_vpn_clients" "get_vpn_client_details"
        "list_vpn_servers" "get_vpn_server_details"
      ];
    # Secrets are declared in the host's sops config; sops-nix places them at /run/secrets/<name>.
    mcpConfig = {
      home-assistant = {
        type = "stdio";
        command = "${pkgs.writeShellScript "ha-mcp-remote" ''
          exec ${pkgs.mcp-remote}/bin/mcp-remote "$(cat /run/secrets/ha-mcp-webhook-url)" --transport http-only --allow-http
        ''}";
      };
      unifi = {
        type = "stdio";
        command = "${pkgs.writeShellScript "unifi-mcp" ''
          set -a
          . /run/secrets/unifi-mcp-env
          set +a
          # Register every tool individually so read-only ones can be allowlisted.
          export UNIFI_TOOL_REGISTRATION_MODE=eager
          exec ${pkgs.unifi-network-mcp}/bin/unifi-network-mcp
        ''}";
      };
    };
  };
}
