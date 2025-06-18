{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.open-webui;
  inherit (config.networking) domain;
  port = 8085;
  port_redis = 8106;
in {
  services = {
    open-webui = {
      enable = true;
      port = port;
      environmentFile = config.sops.secrets.openWebUiAppSecret.path;
      environment = {
        ENV = "prod";
        DATABASE_URL = "postgresql:///open-webui?host=/run/postgresql";

        GLOBAL_LOG_LEVEL = "WARNING";
        AUDIO_LOG_LEVEL = "WARNING";
        COMFYUI_LOG_LEVEL = "WARNING";
        CONFIG_LOG_LEVEL = "WARNING";
        DB_LOG_LEVEL = "WARNING";
        IMAGES_LOG_LEVEL = "WARNING";
        LITELLM_LOG_LEVEL = "WARNING";
        MAIN_LOG_LEVEL = "WARNING";
        MODELS_LOG_LEVEL = "WARNING";
        OLLAMA_LOG_LEVEL = "WARNING";
        OPENAI_LOG_LEVEL = "WARNING";
        RAG_LOG_LEVEL = "WARNING";
        WEBHOOK_LOG_LEVEL = "WARNING";

        ENABLE_WEBSOCKET_SUPPORT = "True";
        WEBSOCKET_MANAGER = "redis";
        WEBSOCKET_REDIS_URL = "redis://localhost:${builtins.toString port_redis}/0";
        REDIS_URL = "redis://localhost:${builtins.toString port_redis}/0";

        # OLLAMA_API_BASE_URL = "https://ollama.lt-home-vm.xuyh0120.win";
        # WEBUI_URL = "https://ai.xuyh0120.win";
        # OPENAI_API_BASE_URL = "http://uni-api.localhost/v1";

        # ENABLE_LOGIN_FORM = "False";
        ENABLE_SIGNUP = "False";
        ENABLE_OAUTH_SIGNUP = "True";
        OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "True";
        OAUTH_CLIENT_ID = "open-webui";
        OAUTH_SCOPES = "openid profile email groups";
        ENABLE_OAUTH_ROLE_MANAGEMENT = "True";
        OAUTH_ROLES_CLAIM = "groups";
        OPENID_PROVIDER_URL = "https://login.lantian.pub/.well-known/openid-configuration";

        # RAG_EMBEDDING_ENGINE = "ollama";
        # PDF_EXTRACT_IMAGES = "False";
        # RAG_EMBEDDING_MODEL = "jeffh/intfloat-multilingual-e5-large:f16";
        # RAG_EMBEDDING_OPENAI_BATCH_SIZE = "512";
        # RAG_TOP_K = "10";
        # CHUNK_SIZE = "512"; # multilingual-e5-large supports 512 max
        # CHUNK_OVERLAP = "180";
        # CONTENT_EXTRACTION_ENGINE = "tika";
        # TIKA_SERVER_URL = "http://127.0.0.1:${LT.portStr.Tika}";

        # ENABLE_IMAGE_GENERATION = "True";
        # IMAGE_GENERATION_ENGINE = "automatic1111";
        # AUTOMATIC1111_BASE_URL = "https://stable-diffusion.xuyh0120.win";
        # IMAGE_SIZE = "512x512";
        # IMAGE_STEPS = "20";

        # ENABLE_RAG_WEB_SEARCH = "True";
        # ENABLE_SEARCH_QUERY = "True";
        # RAG_WEB_SEARCH_ENGINE = "searxng";
        # SEARXNG_QUERY_URL = "https://searx.xuyh0120.win/search?q=<query>";
        # RAG_WEB_SEARCH_RESULT_COUNT = "10";
        # RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";

        # AUDIO_TTS_ENGINE = "openai";
        # AUDIO_TTS_API_KEY = "unused";
        # AUDIO_TTS_OPENAI_API_BASE_URL = "http://127.0.0.1:${LT.portStr.OpenAIEdgeTTS}";
        # AUDIO_TTS_OPENAI_API_KEY = "unused";
        # AUDIO_TTS_MODEL = "tts-1";
        # AUDIO_TTS_VOICE = "zh-CN-XiaoxiaoNeural";
        # AUDIO_TTS_SPLIT_ON = "punctuation";
      };
    };

    postgresql = {
      ensureDatabases = ["open-webui"];
      ensureUsers = [
        {
          name = "open-webui";
          ensureDBOwnership = true;
        }
      ];
    };

    redis.servers.open-webui = {
      enable = true;
      port = port_redis;
      databases = 1;
      user = "open-webui";
    };

    nginx = {
      virtualHosts = {
        "ai.${domain}" = {
          forceSSL = true;
          enableACME = true;
          # extraConfig = ''
          #   access_log /var/log/nginx/open-webui.access.log;
          # '';

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  systemd.services = {
    open-webui = {
      after = [
        "redis-open-webui.service"
        "postgresql.service"
        # "open-webui-auto-setup.service"
      ];
      requires = [
        "redis-open-webui.service"
        "postgresql.service"
        # "open-webui-auto-setup.service"
      ];
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "open-webui";
        Group = "open-webui";
        Restart = "always";
        RestartSec = "3";
      };
    };
    # open-webui-auto-setup = {
    #   description = "Auto set Open WebUI model configs";
    #   wantedBy = ["multi-user.target"];
    #   before = ["open-webui.service"];
    #   requiredBy = ["open-webui.service"];
    #   path = [
    #     pkgs.postgresql
    #     pkgs.envsubst
    #   ];
    #   script = ''
    #     set -euo pipefail
    #
    #     owsql() {
    #       psql -qtAX -v ON_ERROR_STOP=1 -d open-webui "$@"
    #     }
    #
    #     export ADMIN_ID=$(owsql -c "SELECT id FROM public.user WHERE role = 'admin' ORDER BY created_at ASC LIMIT 1")
    #     echo "Admin ID: $ADMIN_ID"
    #
    #     # export TIMESTAMP=$(date "+%s")
    #     # echo "Timestamp: $TIMESTAMP"
    #
    #     # cat {sqlFile} | envsubst > setup.sql
    #
    #     # owsql -c 'DELETE FROM public.model WHERE base_model_id IS NULL'
    #     # owsql -f setup.sql
    #   '';

    # serviceConfig = {
    #   Type = "oneshot";
    #   Restart = "on-failure";
    #   RestartSec = "5";
    #
    #   RuntimeDirectory = "open-webui-auto-setup";
    #   WorkingDirectory = "/run/open-webui-auto-setup";
    #
    #   User = "open-webui";
    #   Group = "open-webui";
    # };
    # };
  };

  users.users.open-webui = {
    description = "open-webui Service";
    group = "open-webui";
    isSystemUser = true;
    home = cfg.stateDir;
    useDefaultShell = true;
  };
  users.groups.open-webui = {};

  # systemd.services.ollama.serviceConfig = {
  #   DynamicUser = lib.mkForce false;
  # };
}
