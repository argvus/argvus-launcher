#!/usr/bin/env sh

# Show the cheatsheet for an app through Rofi.
# Usage: cheatsheets.sh [hypr|kitty|rofi]

# shellcheck disable=SC1091
ARGVUS_BOOTSTRAP="${ARGVUS_BOOTSTRAP:-${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}/session/sh/bootstrap.sh}"
. "$ARGVUS_BOOTSTRAP"

APP="${1:-hypr}"

if locale_is_pt; then
  _language=pt
  PROMPT="Procurar"
else
  _language=en
  PROMPT="Search"
fi

case "$APP" in
  hypr)
    CHEAT_FILE="$(paths_config hyprland/docs/cheatsheets/${_language}.txt)"
    ;;
  kitty)
    CHEAT_FILE="$(paths_config terminal/docs/${_language}.txt)"
    ;;
  *)
    CHEAT_FILE="$(paths_config "${APP}/docs/cheatsheets/${_language}.txt")"
    ;;
esac

exec rofi -config "$(paths_config launcher/config/config.rasi)" -dmenu -p "$PROMPT" -i -theme-str 'window { width: 1050px; height: 600px;}' < "$CHEAT_FILE"
