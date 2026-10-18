#!/usr/bin/env bash
# Regression test: argvus-snippets must reach the config model through the
# argvus entry point on PATH (argvus config ...). Fake commands are created
# under /tmp/argvus and removed on exit.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="${BIN_DIR:-$ROOT_DIR/src/usr/bin}"

failures=0
pass() { printf 'ok - %s\n' "$1"; }
fail() { printf 'not ok - %s\n' "$1" >&2; failures=$((failures + 1)); }

mkdir -p /tmp/argvus
WORK="$(mktemp -d /tmp/argvus/config-bin.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

COMMANDS="$WORK/commands"
TOOLS="$WORK/tools"
LOG="$WORK/config.log"
PROJECT_DIR="$WORK/project"
mkdir -p "$COMMANDS" "$TOOLS" "$PROJECT_DIR"
: > "$LOG"

# Only the utilities the scripts need. The real argvus binary is deliberately
# absent from this PATH; only the fake below is reachable.
for tool in sh env timeout jq awk cat sed grep tr head tail cut sort uniq wc date dirname basename mktemp realpath readlink mkdir rm rmdir cp mv touch; do
  real="$(command -v "$tool" 2>/dev/null || true)"
  [ -n "$real" ] && ln -sf "$real" "$TOOLS/$tool"
done

# Fake argvus: records each config call. Whole arrays read as empty, and an
# indexed element that does not exist reads as null, as the real tool does.
cat > "$TOOLS/argvus" <<'EOF'
#!/bin/sh
[ "$1" = config ] && shift
printf '%s\n' "$*" >> "$TEST_CONFIG_LOG"
case "$1" in
  get)
    case "$2" in
      */[0-9]*) printf 'null\n' ;;
      *) printf '[]\n' ;;
    esac
    ;;
esac
exit 0
EOF
chmod 755 "$TOOLS/argvus"

run() {
  timeout 20 env -i PATH="$TOOLS" HOME="$WORK" TEST_CONFIG_LOG="$LOG" \
    ARGVUS_COMMANDS_DIR="$COMMANDS" "$@" </dev/null
}

# 1. Snippets list reads config through the same path.
out="$(run /bin/sh "$BIN_DIR/argvus-snippets" list 2>&1)" && status=0 || status=$?
if [ "$status" -eq 0 ] && grep -q '^get /snippets/items' "$LOG"; then
  pass "argvus-snippets list reads config from the private commands directory"
else
  fail "argvus-snippets list reads config from the private commands directory (status $status, output: $out)"
fi
: > "$LOG"

# 4. ARGVUS_CONFIG_BIN still overrides the default, for tests and development.
OVERRIDE="$WORK/override-config"
# The generated script must keep $* unexpanded, so the quotes are literal.
# shellcheck disable=SC2016
printf '#!/bin/sh\nprintf "override %%s\\n" "$*" >> "$TEST_CONFIG_LOG"\nexit 0\n' > "$OVERRIDE"
chmod 755 "$OVERRIDE"
out="$(timeout 20 env -i PATH="$TOOLS" HOME="$WORK" TEST_CONFIG_LOG="$LOG" \
  ARGVUS_CONFIG_BIN="$OVERRIDE" /bin/sh "$BIN_DIR/argvus-snippets" list </dev/null 2>&1)" && status=0 || status=$?
if [ "$status" -eq 0 ] && grep -q '^override config get /snippets/items' "$LOG"; then
  pass "ARGVUS_CONFIG_BIN overrides the default binary"
else
  fail "ARGVUS_CONFIG_BIN overrides the default binary (status $status, output: $out)"
fi

if [ "$failures" -ne 0 ]; then
  printf '%s failure(s)\n' "$failures" >&2
  exit 1
fi
printf 'argvus-launcher config-bin tests ok\n'
