{ pkgs, ...}:
let
  runtimeShell = pkgs.runtimeShell;
in {

  battery = pkgs.writeScriptBin "sb-battery" ''
    # Prints all batteries, their percentage remaining and an emoji corresponding
    # to charge status (🔌 for plugged up, 🔋 for discharging on battery, etc.).

    case $BLOCK_BUTTON in
	  3) notify-send "🔋 Battery module" "🔋: discharging
        🛑: not charging
        ♻: stagnant charge
        🔌: charging
        ⚡: charged
        ❗: battery very low!
        - Scroll to change adjust xbacklight." ;;
	  4) xbacklight -inc 10 ;;
	  5) xbacklight -dec 10 ;;
	  6) "$TERMINAL" -e "$EDITOR" "$0" ;;
    esac

    # Loop through all attached batteries and format the info
    for battery in /sys/class/power_supply/BAT?*; do
	  # If non-first battery, print a space separator.
	  [ -n "$(capacity+x)" ] && printf " "
	  # Sets up the status and capacity
	  case "$(cat "$battery/status")" in
	    "Full") status="⚡" ;;
		"Discharging") status="🔋" ;;
		"Charging") status="🔌" ;;
		"Not charging") status="🛑" ;;
		"Unknown") status="♻️" ;;
	  esac
	  capacity=$(cat "$battery/capacity")
	  # Will make a warn variable if discharging and low
	  [ "$status" = "🔋" ] && [ "$capacity" -le 25 ] && warn="❗"
	  # Prints the info
	  printf "%s%s%d%%" "$status" "$warn" "$capacity"; unset warn
    done && exit 0
  '';

  memory = pkgs.writeScriptBin "sb-memory" ''
    case $BLOCK_BUTTON in
	  1) notify-send "🧠 Memory hogs" "$(ps axch -o cmd:15,%mem --sort=-%mem | head)" ;;
	  2) setsid -f "$TERMINAL" -e htop ;;
	  3) notify-send "🧠 Memory module" "\- Shows Memory Used/Total.
        - Click to show memory hogs.
        - Middle click to open htop." ;;
	  6) "$TERMINAL" -e "$EDITOR" "$0" ;;
    esac

    free --mebi | sed -n '2{p;q}' | awk '{printf ("🧠%2.2fGiB/%2.2fGiB\n", ( $3 / 1024), ($2 / 1024))}'
  '';

  cpu = pkgs.writeScriptBin "sb-cpu" ''
    case $BLOCK_BUTTON in
	  1) notify-send "🖥 CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)\\n(100% per core)" ;;
 	  2) setsid -f "$TERMINAL" -e htop ;;
	  3) notify-send "🖥 CPU module " "\- Shows CPU temperature.
        - Click to show intensive processes.
        - Middle click to open htop." ;;
	  6) "$TERMINAL" -e "$EDITOR" "$0" ;;
    esac
    sensors | awk '/Core 0/ {print "🌡" $3}'
  '';

  clock = pkgs.writeScriptBin "sb-clock" ''
    clock=$(date '+%I')

    case $BLOCK_BUTTON in
	  1) notify-send "This Month" "$(cal --color=always | sed "s/..7m/<b><span color=\"red\">/;s/..27m/<\/span><\/b>/")" && notify-send "Appointments" "$(calcurse -d3)" ;;
	  2) setsid -f "$TERMINAL" -e calcurse ;;
	  3) notify-send "📅 Time/date module" "\- Left click to show upcoming appointments for the next three days via \`calcurse -d3\` and show the month via \`cal\`
        - Middle click opens calcurse if installed" ;;
	  6) "$TERMINAL" -e "$EDITOR" "$0" ;;
    esac
    date "+%Y %b %d (%a) %I:%M%p"
  '';

}
