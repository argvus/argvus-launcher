#!/usr/bin/env sh

# Show the cheatsheet for an app through Rofi.
# Usage: cheatsheets.sh [hypr|kitty|rofi]

# shellcheck disable=SC1090,SC1091
ARGVUS_BOOTSTRAP="${ARGVUS_BOOTSTRAP:-${ARGVUS_SYSTEM_CONFIG:-/usr/share/argvus}/session/sh/bootstrap.sh}"
. "$ARGVUS_BOOTSTRAP"

APP="${1:-hypr}"

if locale_is_pt; then
  _language=pt
else
  _language=en
fi
PROMPT="$(argvus_tr launcher search.cheatsheet)"

case "$APP" in
  hypr)
    _generated_cheat="${ARGVUS_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/argvus}/generated/hypr/keybindings.txt"
    if [ -r "$_generated_cheat" ]; then
      CHEAT_FILE="$_generated_cheat"
    else
      CHEAT_FILE="$(paths_config hyprland/docs/cheatsheets/${_language}.txt)"
    fi
    ;;
  kitty)
    CHEAT_FILE="$(paths_config terminal/docs/${_language}.txt)"
    ;;
  *)
    CHEAT_FILE="$(paths_config "${APP}/docs/cheatsheets/${_language}.txt")"
    ;;
esac

exec rofi -config "$(paths_config launcher/config/config.rasi)" -dmenu -p "$PROMPT" -i -theme-str 'window { width: 1050px; height: 600px;}' < "$CHEAT_FILE"
