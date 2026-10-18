#!/usr/bin/env bash
# Tests for argvus-git.
# Every external tool is a fake created under /tmp/argvus and removed on exit.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="${BIN_DIR:-$ROOT_DIR/src/usr/bin}"

failures=0
pass() { printf 'ok - %s\n' "$1"; }
fail() { printf 'not ok - %s\n' "$1" >&2; failures=$((failures + 1)); }

mkdir -p /tmp/argvus
WORK="$(mktemp -d /tmp/argvus/git.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

FAKEBIN="$WORK/fakebin"
TOOLS="$WORK/tools"
REPO="$WORK/repo with space"
PLAIN="$WORK/plain dir"
mkdir -p "$FAKEBIN" "$TOOLS" "$PLAIN"

# Only the utilities the scripts need. git is linked for real: the scripts run
# it against the repository created below.
for tool in sh env timeout awk cat sed grep tr head tail cut sort uniq wc basename dirname mkdir rm cp mv touch git printf; do
  real="$(command -v "$tool" 2>/dev/null || true)"
  [ -n "$real" ] && ln -sf "$real" "$TOOLS/$tool"
done

git init -q "$REPO"
git -C "$REPO" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init

# Fake argvus dispatcher. `projects pick` prints FAKE_PICK_OUT and exits with
# FAKE_PICK_STATUS; `tui-terminal` prints each argument bracketed.
cat > "$FAKEBIN/argvus" <<'FAKE'
#!/bin/sh
case "$1" in
  projects)
    printf '%s' "${FAKE_PICK_OUT:-}"
    exit "${FAKE_PICK_STATUS:-0}"
    ;;
  tui-terminal)
    for a do printf '[%s]\n' "$a"; done
    exit 0
    ;;
esac
exit 2
FAKE

# Fake lazygit: only has to exist on PATH for the tool selection.
printf '#!/bin/sh\nexit 0\n' > "$FAKEBIN/lazygit"

# Fake rofi: picks index 0, or cancels with status 1 when FAKE_ROFI=cancel.
cat > "$FAKEBIN/rofi" <<'FAKE'
#!/bin/sh
cat >/dev/null
[ "${FAKE_ROFI:-select}" = cancel ] && exit 1
printf '0\n'
FAKE

chmod 755 "$FAKEBIN/argvus" "$FAKEBIN/lazygit" "$FAKEBIN/rofi"

run_git() {
  env -i PATH="$FAKEBIN:$TOOLS" HOME="$WORK" \
    ARGVUS_BOOTSTRAP=/nonexistent ARGVUS_GIT_TUI=lazygit \
    "$@"
}

# 1. A directory argument opens the TUI there, without the picker.
out="$(run_git FAKE_PICK_STATUS=9 sh "$BIN_DIR/argvus-git" "$REPO" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && printf '%s\n' "$out" | grep -qxF "[$REPO]"; then
  pass "argvus git DIR opens the TUI in DIR without the picker"
else
  fail "argvus git DIR opens the TUI in DIR (rc $rc, output: $out)"
fi

# 2. No argument: the picked project is used, with spaces intact.
out="$(run_git FAKE_PICK_OUT="$REPO" sh "$BIN_DIR/argvus-git" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && printf '%s\n' "$out" | grep -qxF "[$REPO]"; then
  pass "argvus git opens the TUI in the picked project"
else
  fail "argvus git opens the TUI in the picked project (rc $rc, output: $out)"
fi

# 3. Cancelling the picker exits 0 and opens nothing.
out="$(run_git FAKE_PICK_OUT="" sh "$BIN_DIR/argvus-git" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -eq 0 ] && ! printf '%s\n' "$out" | grep -q 'tui-terminal'; then
  pass "a cancelled picker opens nothing"
else
  fail "a cancelled picker opens nothing (rc $rc, output: $out)"
fi

# 4. A picker failure is propagated and nothing opens.
out="$(run_git FAKE_PICK_STATUS=1 sh "$BIN_DIR/argvus-git" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -ne 0 ] && ! printf '%s\n' "$out" | grep -q 'tui-terminal'; then
  pass "a picker failure stops argvus git"
else
  fail "a picker failure stops argvus git (rc $rc, output: $out)"
fi

# 5. A directory that is not a git repository is refused.
out="$(run_git sh "$BIN_DIR/argvus-git" "$PLAIN" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -ne 0 ] && ! printf '%s\n' "$out" | grep -q 'tui-terminal'; then
  pass "a non-repository is refused"
else
  fail "a non-repository is refused (rc $rc, output: $out)"
fi

# 6. Without any TUI installed, the command stops with an error.
out="$(run_git ARGVUS_GIT_TUI=no-such-tui sh "$BIN_DIR/argvus-git" "$REPO" 2>&1)" && rc=0 || rc=$?
if [ "$rc" -ne 0 ] && ! printf '%s\n' "$out" | grep -q 'tui-terminal'; then
  pass "a missing TUI stops argvus git"
else
  fail "a missing TUI stops argvus git (rc $rc, output: $out)"
fi

if [ "$failures" -ne 0 ]; then
  printf '%s failure(s)\n' "$failures" >&2
  exit 1
fi
printf 'argvus git tests ok\n'
