#!/usr/bin/env bash
# Regression test: argvus-keys manages key pairs under ARGVUS_SSH_DIR and the
# agent through ssh-keygen, ssh-add and hyprctl. All three are fakes created
# under /tmp/argvus and removed on exit, so no real key or agent is touched.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="${BIN_DIR:-$ROOT_DIR/src/usr/bin}"

failures=0
pass() { printf 'ok - %s\n' "$1"; }
fail() { printf 'not ok - %s\n' "$1" >&2; failures=$((failures + 1)); }

mkdir -p /tmp/argvus
WORK="$(mktemp -d /tmp/argvus/keys.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

FAKEBIN="$WORK/fakebin"
TOOLS="$WORK/tools"
SSH="$WORK/ssh"
SYSTEM="$WORK/system"
HYPR_LOG="$WORK/hyprctl.log"
SSH_LOG="$WORK/ssh.log"
AGENT="$WORK/agent.txt"
mkdir -p "$FAKEBIN" "$TOOLS" "$SSH" "$SYSTEM/lib" "$WORK/home"
: > "$HYPR_LOG"
: > "$SSH_LOG"
: > "$AGENT"

# Only the utilities the script needs. ssh-keygen, ssh-add and hyprctl come
# from FAKEBIN alone.
for tool in sh env timeout awk sed grep cat tr head cut wc basename dirname mkdir rm chmod stat mktemp; do
  real="$(command -v "$tool" 2>/dev/null || true)"
  [ -n "$real" ] && ln -sf "$real" "$TOOLS/$tool"
done

# argvus_tr stub: prints the key, so messages can be checked by key name.
cat > "$SYSTEM/lib/i18n.sh" <<'EOF'
argvus_tr() { printf '%s\n' "$2"; }
EOF

# Fake ssh-keygen. Private files containing ENCRYPTED need a passphrase, so
# "-y -P ''" fails for them. A public file is "ssh-TYPE AAA-NAME COMMENT", and
# its fingerprint is SHA256:AAA-NAME.
cat > "$FAKEBIN/ssh-keygen" <<'EOF'
#!/bin/sh
printf 'ssh-keygen %s\n' "$*" >> "$TEST_SSH_LOG"
case "$1" in
  -lf)
    awk '{ t = $1; sub(/^ssh-/, "", t); if (t == "ed25519") T = "ED25519"; else T = "RSA";
           print "256 SHA256:" $2, $3, "(" T ")" }' "$2"
    ;;
  -y)
    priv="$5"
    if grep -q ENCRYPTED "$priv"; then exit 1; fi
    cat "$priv.pub"
    ;;
  *)
    # Generation: -q -t TYPE [-b N] -f PATH -C COMMENT [-N '']
    path=''
    comment=''
    type=''
    while [ "$#" -gt 0 ]; do
      case "$1" in
        -t) type=$2; shift ;;
        -f) path=$2; shift ;;
        -C) comment=$2; shift ;;
        -b|-N) shift ;;
      esac
      shift
    done
    name=$(basename "$path")
    printf 'PRIVATE\n' > "$path"
    printf 'ssh-%s AAA-%s %s\n' "$type" "$name" "$comment" > "$path.pub"
    ;;
esac
EOF

# Fake ssh-add. The agent is the fingerprint list in AGENT; FAKE_AGENT_DOWN=1
# makes it unreachable (exit 2).
cat > "$FAKEBIN/ssh-add" <<'EOF'
#!/bin/sh
printf 'ssh-add %s sock=%s\n' "$*" "${SSH_AUTH_SOCK:-}" >> "$TEST_SSH_LOG"
case "$1" in
  -l)
    if [ -n "${FAKE_AGENT_DOWN:-}" ]; then exit 2; fi
    [ -s "$TEST_AGENT" ] || exit 1
    cat "$TEST_AGENT"
    ;;
  -d)
    name=$(basename "$2" .pub)
    if grep -q "SHA256:AAA-$name " "$TEST_AGENT" 2>/dev/null; then
      exit 0
    fi
    exit 1
    ;;
  -D)
    : > "$TEST_AGENT"
    ;;
  *)
    exit 0
    ;;
esac
EOF

# Fake hyprctl: records the dispatch string, which is what the terminal step
# would receive.
cat > "$FAKEBIN/hyprctl" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$TEST_HYPR_LOG"
EOF

# Fake notify-send is absent on purpose: report_error skips the call.
chmod 755 "$FAKEBIN/ssh-keygen" "$FAKEBIN/ssh-add" "$FAKEBIN/hyprctl"

# Runs argvus-keys in isolation with the given arguments. FAKE_AGENT_DOWN is
# forwarded only when a test sets it in the caller's environment.
run_keys() {
  env -i PATH="$TOOLS:$FAKEBIN" HOME="$WORK/home" \
    ARGVUS_SYSTEM_CONFIG="$SYSTEM" ARGVUS_BOOTSTRAP=/nonexistent \
    ARGVUS_SSH_DIR="$SSH" TEST_SSH_LOG="$SSH_LOG" TEST_HYPR_LOG="$HYPR_LOG" \
    TEST_AGENT="$AGENT" XDG_RUNTIME_DIR="$WORK/run" \
    ${FAKE_AGENT_DOWN:+FAKE_AGENT_DOWN=$FAKE_AGENT_DOWN} \
    timeout 20 sh "$BIN_DIR/argvus-keys" "$@" </dev/null
}

# Seeds the ssh directory: alpha is plain and loaded, beta is encrypted and
# not loaded, orphan has no public file.
seed() {
  rm -rf "$SSH"
  mkdir -p "$SSH"
  printf 'PRIVATE\n' > "$SSH/alpha"
  printf 'ssh-ed25519 AAA-alpha alpha@test\n' > "$SSH/alpha.pub"
  printf 'ENCRYPTED\n' > "$SSH/beta"
  printf 'ssh-rsa AAA-beta beta@test\n' > "$SSH/beta.pub"
  printf 'PRIVATE\n' > "$SSH/orphan"
  printf '256 SHA256:AAA-alpha alpha@test (ED25519)\n' > "$AGENT"
  : > "$HYPR_LOG"
  : > "$SSH_LOG"
}

# 1. list prints one TSV row per key pair, with passphrase and loaded state.
# orphan has no .pub, so it must not appear.
seed
out="$(run_keys list 2>&1 || true)"
expected_alpha=$'alpha\ted25519\tSHA256:AAA-alpha\talpha@test\tno\tyes'
expected_beta=$'beta\trsa\tSHA256:AAA-beta\tbeta@test\tyes\tno'
if printf '%s\n' "$out" | grep -Fxq "$expected_alpha" && printf '%s\n' "$out" | grep -Fxq "$expected_beta" && ! printf '%s\n' "$out" | grep -q orphan; then
  pass "list prints each key pair with type, fingerprint, passphrase and loaded state"
else
  fail "list output unexpected: $out"
fi

# 2. With the agent unreachable, the loaded column reads unknown.
seed
out="$(FAKE_AGENT_DOWN=1 run_keys list 2>&1 || true)"
if printf '%s\n' "$out" | grep -Fq $'alpha\ted25519\tSHA256:AAA-alpha\talpha@test\tno\tunknown'; then
  pass "list reports loaded as unknown when the agent is unreachable"
else
  fail "list with agent down unexpected: $out"
fi

# 3. Invalid names are refused and nothing is created.
seed
status=0
out="$(run_keys generate '../escape' 2>&1)" || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$WORK/escape" ]; then
  pass "generate refuses a name with path traversal"
else
  fail "generate accepted a traversal name (status $status): $out"
fi

# 4. A name that already exists is refused without touching the pair.
seed
status=0
run_keys generate alpha >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ "$(cat "$SSH/alpha")" = PRIVATE ] && [ "$(cat "$SSH/alpha.pub")" = 'ssh-ed25519 AAA-alpha alpha@test' ]; then
  pass "generate refuses to overwrite an existing key"
else
  fail "generate overwrote alpha (status $status)"
fi

# 5. A new rsa key is generated with 4096 bits, an empty passphrase and mode 600.
seed
run_keys generate gamma --type rsa --comment ops >/dev/null 2>&1
mode="$(stat -c %a "$SSH/gamma" 2>/dev/null || true)"
if [ -f "$SSH/gamma" ] && [ -f "$SSH/gamma.pub" ] && grep -q 'ssh-rsa AAA-gamma ops' "$SSH/gamma.pub" \
  && grep -q -- '-b 4096' "$SSH_LOG" && grep -q -- "-N " "$SSH_LOG" && [ "$mode" = 600 ]; then
  pass "generate --type rsa writes a 4096-bit pair with mode 600"
else
  fail "generate rsa did not produce the expected pair (mode $mode)"
fi

# 6. An unknown type is refused.
seed
status=0
run_keys generate delta --type dsa >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$SSH/delta" ]; then
  pass "generate refuses an unsupported key type"
else
  fail "generate accepted dsa (status $status)"
fi

# 7. Passphrase generation is handed to an ARGVUS terminal, with no secret in
# the command line.
seed
run_keys generate delta --passphrase >/dev/null 2>&1
if grep -q 'argvus keys generate-run delta --type ed25519 --comment delta' "$HYPR_LOG" && [ ! -e "$SSH/delta" ]; then
  pass "generate --passphrase opens a terminal instead of prompting here"
else
  fail "generate --passphrase did not dispatch to a terminal: $(cat "$HYPR_LOG")"
fi

# 8. load of a passphrase-protected key outside a TTY opens a terminal.
seed
run_keys load beta >/dev/null 2>&1
if grep -q 'argvus keys load-run beta' "$HYPR_LOG"; then
  pass "load opens an ARGVUS terminal for a key with a passphrase"
else
  fail "load did not dispatch: $(cat "$HYPR_LOG")"
fi

# 8b. load of a key without a passphrase runs ssh-add here and opens no terminal.
seed
run_keys load alpha >/dev/null 2>&1
if [ ! -s "$HYPR_LOG" ] && grep -q "ssh-add $SSH/alpha sock=" "$SSH_LOG"; then
  pass "load adds a key without a passphrase without opening a terminal"
else
  fail "load of a plain key opened a terminal or skipped ssh-add: $(cat "$HYPR_LOG")"
fi

# 9. load-run adds the key to the agent inside the terminal.
seed
run_keys load-run beta >/dev/null 2>&1
if grep -q "ssh-add $SSH/beta" "$SSH_LOG"; then
  pass "load-run runs ssh-add on the key file"
else
  fail "load-run did not call ssh-add: $(cat "$SSH_LOG")"
fi

# 10. unload removes a loaded key and refuses one that is not loaded.
seed
run_keys unload alpha >/dev/null 2>&1
status=0
run_keys unload beta >/dev/null 2>&1 || status=$?
if grep -q "ssh-add -d $SSH/alpha.pub" "$SSH_LOG" && [ "$status" -ne 0 ]; then
  pass "unload removes a loaded key and reports one that is not loaded"
else
  fail "unload behaved unexpectedly (beta status $status)"
fi

# 11. unload-all calls ssh-add -D.
seed
run_keys unload-all >/dev/null 2>&1
if grep -q -- 'ssh-add -D' "$SSH_LOG"; then
  pass "unload-all calls ssh-add -D"
else
  fail "unload-all did not call ssh-add -D"
fi

# 12. delete refuses a loaded key, leaving both files in place.
seed
status=0
run_keys delete alpha >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ -f "$SSH/alpha" ] && [ -f "$SSH/alpha.pub" ]; then
  pass "delete refuses a key that is loaded in the agent"
else
  fail "delete removed a loaded key (status $status)"
fi

# 13. delete refuses a key without its public file.
seed
status=0
run_keys delete orphan >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ -f "$SSH/orphan" ]; then
  pass "delete refuses a key without a public file"
else
  fail "delete removed orphan (status $status)"
fi

# 14. delete removes both files of an unloaded key pair.
seed
run_keys delete beta >/dev/null 2>&1
if [ ! -e "$SSH/beta" ] && [ ! -e "$SSH/beta.pub" ]; then
  pass "delete removes both files of an unloaded key pair"
else
  fail "delete left beta behind"
fi

# 15. The passphrase is never passed as a process argument. The only ssh-keygen
# calls that carry a secret would show it in the log, so none may appear.
seed
run_keys generate epsilon --passphrase >/dev/null 2>&1
run_keys load beta >/dev/null 2>&1
if ! grep -qi 'pass' "$SSH_LOG" "$HYPR_LOG"; then
  pass "generate --passphrase and load log no passphrase-related argument"
else
  fail "a passphrase-related argument was logged"
fi

# 17. Without SSH_AUTH_SOCK, the agent socket of the session service is used,
# because terminals opened by Hyprland do not inherit the variable.
seed
run_keys load-run beta >/dev/null 2>&1
if grep -q "sock=$WORK/run/ssh-agent.socket" "$SSH_LOG"; then
  pass "missing SSH_AUTH_SOCK falls back to the session agent socket"
else
  fail "ssh-add did not get the agent socket: $(cat "$SSH_LOG")"
fi

# 16. Without arguments the script prints help and exits 0.
seed
out="$(run_keys 2>&1)"
if [ "$out" = help.keys ]; then
  pass "no arguments prints the help text"
else
  fail "help output unexpected: $out"
fi

[ "$failures" -ne 0 ] && { printf '%s failure(s)\n' "$failures" >&2; exit 1; }
printf 'argvus-keys tests ok\n'
