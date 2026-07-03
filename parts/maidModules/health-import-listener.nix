{
  flake.maidModules.health-import-listener = {
    pkgs,
    config,
    lib,
    ...
  }: let
    cfg = config.health-import-listener;

    script = pkgs.writeText "health_import_listener.py" ''
      #!/usr/bin/env python3
      import json
      import os
      import sys
      import tempfile
      from datetime import datetime, timezone
      from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

      INBOX = os.environ.get("HEALTH_IMPORT_DIR")
      PORT = int(os.environ.get("HEALTH_IMPORT_PORT", "9871"))
      MAX_BODY_BYTES = 25 * 1024 * 1024

      if not INBOX:
          sys.exit("HEALTH_IMPORT_DIR is required")

      TOKEN = ""
      token_file = os.environ.get("HEALTH_IMPORT_TOKEN_FILE", "")
      if token_file:
          try:
              with open(token_file) as f:
                  TOKEN = f.read().strip()
          except OSError as e:
              sys.exit(f"cannot read HEALTH_IMPORT_TOKEN_FILE: {e}")

      os.makedirs(INBOX, exist_ok=True)


      class Handler(BaseHTTPRequestHandler):
          server_version = "health-import-listener/1.0"

          def _respond(self, code, body=b""):
              self.send_response(code)
              self.send_header("Content-Type", "text/plain")
              self.end_headers()
              if body:
                  self.wfile.write(body)

          def do_POST(self):
              if TOKEN:
                  if self.headers.get("Authorization", "") != f"Bearer {TOKEN}":
                      self._respond(401)
                      return

              try:
                  length = int(self.headers.get("Content-Length", 0))
              except ValueError:
                  length = 0

              if length <= 0 or length > MAX_BODY_BYTES:
                  self._respond(400, b"bad content length\n")
                  return

              raw = self.rfile.read(length)

              try:
                  parsed = json.loads(raw)
              except json.JSONDecodeError as e:
                  self._respond(400, f"invalid json: {e}\n".encode())
                  return

              ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H-%M-%S-%f")
              dest = os.path.join(INBOX, f"{ts}.json")

              fd, tmp_path = tempfile.mkstemp(dir=INBOX, prefix=".tmp-", suffix=".json")
              try:
                  with os.fdopen(fd, "w") as f:
                      json.dump(parsed, f)
                  os.rename(tmp_path, dest)
              except Exception:
                  os.unlink(tmp_path)
                  raise

              print(f"[health-import] wrote {dest} ({length} bytes)")
              self._respond(200, b"ok\n")

          def log_message(self, fmt, *args):
              print("[health-import] " + (fmt % args))


      if __name__ == "__main__":
          server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
          print(f"[health-import] listening on :{PORT}, writing to {INBOX}")
          server.serve_forever()
    '';
  in {
    options.health-import-listener = {
      importDir = lib.mkOption {
        type = lib.types.str;
        description = "Absolute path to the vault's Health Auto Export inbox folder";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9871;
        description = "Port the listener binds to (only reachable over Tailscale)";
      };

      tokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the Bearer token. If null, auth is disabled.";
      };
    };

    config = {
      systemd.services.health-import-listener = {
        description = "Health Auto Export REST listener";
        wantedBy = ["default.target"];

        environment =
          {
            HEALTH_IMPORT_DIR = cfg.importDir;
            HEALTH_IMPORT_PORT = toString cfg.port;
          }
          // lib.optionalAttrs (cfg.tokenFile != null) {
            HEALTH_IMPORT_TOKEN_FILE = toString cfg.tokenFile;
          };

        serviceConfig = {
          ExecStart = "${pkgs.python3}/bin/python3 ${script}";
          Restart = "on-failure";
        };
      };
    };
  };
}
