# Start/stop the headless Obsidian on polarvortex. It is not started at boot
# because two Obsidians writing the same Syncthing vault cause sync conflicts.
# From any other host, the command is forwarded to polarvortex over ssh.
set -eu

if [ "$(hostname)" != polarvortex ]; then
  exec ssh -t polarvortex "./obsidian-headless $*"
fi

unit=obsidian-xvfb.service
case "${1:-status}" in
  start | stop | restart) doas systemctl "$1" "$unit" && systemctl --no-pager status "$unit" | head -3 ;;
  status) systemctl --no-pager status "$unit" ;;
  logs) journalctl -u "$unit" -f ;;
  *)
    echo "usage: obsidian-headless {start|stop|restart|status|logs}" >&2
    exit 1
    ;;
esac
