#!/usr/bin/env sh

# Show the cheatsheet for an app through Rofi.
# Usage: cheatsheets.sh [hypr|kitty|rofi]

# shellcheck disable=SC1091
ARGVUS_BOOTSTRAP="${ARGVUS_BOOTSTRAP:-${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}/scripts/argvus/bootstrap.sh}"
. "$ARGVUS_BOOTSTRAP"

APP="${1:-hypr}"

if locale_is_pt; then
  if [ "$APP" = "kitty" ]; then
    CHEAT_FILE="/usr/share/argvus-terminal/kitty/docs/cheatsheets/pt.txt"
  else
    CHEAT_FILE="$(paths_config "$APP/docs/cheatsheets/pt.txt")"
  fi
  PROMPT="Procurar"
else
  if [ "$APP" = "kitty" ]; then
    CHEAT_FILE="/usr/share/argvus-terminal/kitty/docs/cheatsheets/en.txt"
  else
    CHEAT_FILE="$(paths_config "$APP/docs/cheatsheets/en.txt")"
  fi
  PROMPT="Search"
fi

exec rofi -config "$(paths_config rofi/config.rasi)" -dmenu -p "$PROMPT" -i -theme-str 'window { width: 1050px; height: 600px;}' < "$CHEAT_FILE"
