#!/usr/bin/env bash
# Regression test: argvus-gpg manages keys and gpg-agent.conf through gpg,
# gpgconf and pinentry. All of them are fakes created under /tmp/argvus and
# removed on exit, so no real keyring, agent or configuration is touched.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="${BIN_DIR:-$ROOT_DIR/src/usr/bin}"

failures=0
pass() { printf 'ok - %s\n' "$1"; }
fail() { printf 'not ok - %s\n' "$1" >&2; failures=$((failures + 1)); }

mkdir -p /tmp/argvus
WORK="$(mktemp -d /tmp/argvus/gpg.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

FAKEBIN="$WORK/fakebin"
TOOLS="$WORK/tools"
SYSTEM="$WORK/system"
FAKE="$WORK/fake"
GNUPG="$WORK/gnupg"
GPG_LOG="$WORK/gpg.log"
GPGCONF_LOG="$WORK/gpgconf.log"
mkdir -p "$FAKEBIN" "$TOOLS" "$SYSTEM/lib" "$FAKE" "$WORK/home"
: > "$GPG_LOG"
: > "$GPGCONF_LOG"

# Only the utilities the script needs. gpg, gpgconf and the pinentry programs
# come from FAKEBIN alone.
for tool in sh env timeout awk sed grep cat tr head cut wc basename dirname mkdir rm mv cp chmod stat mktemp date tail ls; do
  real="$(command -v "$tool" 2>/dev/null || true)"
  [ -n "$real" ] && ln -sf "$real" "$TOOLS/$tool"
done

# argvus_tr stub: prints the key, so messages can be checked by key name.
cat > "$SYSTEM/lib/i18n.sh" <<'EOF'
argvus_tr() { printf '%s\n' "$2"; }
EOF

# Fake gpg. Every call is logged with each argument in brackets, so an empty
# passphrase is visible as []. Behavior comes from files in FAKE:
#   public, secret   colon listings for --list-keys and --list-secret-keys
#   gen-fail         quick-gen-key fails
#   sub-fail         quick-add-key fails
# A file given to --list-packets containing SECRET reports a secret key packet.
cat > "$FAKEBIN/gpg" <<'EOF'
#!/bin/sh
printf 'gpg' >> "$TEST_GPG_LOG"
for a in "$@"; do printf ' [%s]' "$a" >> "$TEST_GPG_LOG"; done
printf '\n' >> "$TEST_GPG_LOG"

cmd=''
for a in "$@"; do
  case "$a" in
    --list-secret-keys|--list-keys|--list-packets|--quick-gen-key|--quick-add-key|--export|--import)
      cmd=$a ;;
  esac
done
case "$cmd" in
  --list-secret-keys)
    [ -f "$FAKE_DIR/secret" ] && cat "$FAKE_DIR/secret"
    ;;
  --list-keys)
    [ -f "$FAKE_DIR/public" ] && cat "$FAKE_DIR/public"
    ;;
  --list-packets)
    file=$(eval "printf %s \"\${$#}\"")
    if grep -q SECRET "$file"; then
      printf ':secret key packet:\n'
    else
      printf ':public key packet:\n'
    fi
    ;;
  --quick-gen-key)
    [ ! -e "$FAKE_DIR/gen-fail" ] || exit 2
    printf '[GNUPG:] KEY_CREATED P AAAA111122223333AAAA111122223333AAAAAAAA\n'
    ;;
  --quick-add-key)
    [ ! -e "$FAKE_DIR/sub-fail" ] || exit 2
    ;;
  --export)
    id=$(eval "printf %s \"\${$#}\"")
    if [ "$id" = alice@example.com ]; then
      printf -- '-----BEGIN PGP PUBLIC KEY BLOCK-----\nfake\n-----END PGP PUBLIC KEY BLOCK-----\n'
    fi
    ;;
  --import)
    ;;
esac
exit 0
EOF

# Fake gpgconf: logs the call only.
cat > "$FAKEBIN/gpgconf" <<'EOF'
#!/bin/sh
printf 'gpgconf %s\n' "$*" >> "$TEST_GPGCONF_LOG"
EOF

# Fake pinentry programs. Only pinentry-qt is installed, so curses is missing.
cat > "$FAKEBIN/pinentry-qt" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod 755 "$FAKEBIN/gpg" "$FAKEBIN/gpgconf" "$FAKEBIN/pinentry-qt"

# Runs argvus-gpg in isolation with the given arguments.
run_gpg() {
  env -i PATH="$TOOLS:$FAKEBIN" HOME="$WORK/home" GNUPGHOME="$GNUPG" \
    ARGVUS_SYSTEM_CONFIG="$SYSTEM" ARGVUS_BOOTSTRAP=/nonexistent \
    FAKE_DIR="$FAKE" TEST_GPG_LOG="$GPG_LOG" TEST_GPGCONF_LOG="$GPGCONF_LOG" \
    timeout 20 sh "$BIN_DIR/argvus-gpg" "$@" </dev/null
}

# Colon listings in the layout gpg prints with --with-colons. Alice has an
# encryption subkey, which must not appear as a row of its own. Bob is
# expired, carries an escaped colon in his user ID, and is not a secret key.
# Only Alice's primary key is secret.
write_fixtures() {
  rm -f "$FAKE"/*
  cat > "$FAKE/public" <<'EOF'
tru:o:0:0:1:3:1:5
pub:u:255:22:AAAA111122223333:1700000000::::u:::scESC:::::ed25519:::0:
fpr:::::::::AAAA111122223333AAAA111122223333AAAAAAAA:
uid:u::::1700000000::HASH1::Alice Example <alice@example.com>::::::::::0:
uid:u::::1700000000::HASH2::Alice Second <second@example.com>::::::::::0:
sub:u:255:18:BBBBBBBBBBBBBBBB:1700000000:::::e:::::cv25519:::
fpr:::::::::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB:
pub:e:4096:1:CCCCCCCCCCCCCCCC:1600000000:1900000000::::::::23::0:
fpr:::::::::CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEE:
uid:e::::1600000000::HASH3::Bob\x3a Test <bob@example.com>::::::::::0:
EOF
  cat > "$FAKE/secret" <<'EOF'
sec:u:255:22:AAAA111122223333:1700000000::::u:::scESC:::+::ed25519:::0:
fpr:::::::::AAAA111122223333AAAA111122223333AAAAAAAA:
grp:::::::::1111111111111111111111111111111111111111:
uid:u::::1700000000::HASH1::Alice Example <alice@example.com>::::::::::0:
EOF
}

# Clears the log files and the gpg home, so each case starts clean.
reset_case() {
  : > "$GPG_LOG"
  : > "$GPGCONF_LOG"
  rm -rf "$GNUPG"
  mkdir -p "$GNUPG"
  chmod 700 "$GNUPG"
}

# 1. list prints one TSV row per primary key, with the secret flag and the
# expiry date. The subkey is not a row, and the escaped colon is restored.
write_fixtures
reset_case
out="$(run_gpg list 2>&1 || true)"
expected_alice=$'AAAA111122223333AAAA111122223333AAAAAAAA\tAAAA111122223333\ted25519\tnever\tyes\tu\tAlice Example <alice@example.com>'
expected_bob=$'CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEE\tCCCCCCCCCCCCCCCC\trsa\t2030-03-17\tno\te\tBob: Test <bob@example.com>'
rows="$(printf '%s\n' "$out" | grep -c .)"
if printf '%s\n' "$out" | grep -Fxq "$expected_alice" && printf '%s\n' "$out" | grep -Fxq "$expected_bob" && [ "$rows" -eq 2 ]; then
  pass "list prints one row per primary key with secret flag, expiry and escaped user ID"
else
  fail "list output unexpected ($rows rows): $out"
fi

# 2. An empty keyring lists nothing and succeeds.
rm -f "$FAKE/public" "$FAKE/secret"
reset_case
status=0
out="$(run_gpg list 2>&1)" || status=$?
if [ "$status" -eq 0 ] && [ -z "$out" ]; then
  pass "list on an empty keyring prints nothing and exits 0"
else
  fail "list on empty keyring (status $status): $out"
fi
write_fixtures

# 3. Invalid generate arguments are refused before gpg runs.
reset_case
status=0
run_gpg generate '-bad' >/dev/null 2>&1 || status=$?
run_gpg generate 'Name' --algo dsa >/dev/null 2>&1 || true
if [ "$status" -ne 0 ] && ! grep -q 'quick-gen-key' "$GPG_LOG"; then
  pass "generate refuses a leading dash and an unknown algorithm before calling gpg"
else
  fail "generate accepted invalid arguments: $(cat "$GPG_LOG")"
fi

reset_case
status=0
run_gpg generate 'Name' --expire soon >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && ! grep -q 'quick-gen-key' "$GPG_LOG"; then
  pass "generate refuses an invalid expiry"
else
  fail "generate accepted an invalid expiry"
fi

# 4. A key with a passphrase is created through the pinentry: no batch mode,
# no passphrase argument, and an encryption subkey added to the new key.
reset_case
run_gpg generate 'Carol <carol@example.com>' --expire 2y >/dev/null 2>&1
if grep -q '\[--quick-gen-key\] \[Carol <carol@example.com>\] \[ed25519\] \[default\] \[2y\]' "$GPG_LOG" \
  && grep -q '\[--quick-add-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[cv25519\] \[encr\] \[2y\]' "$GPG_LOG" \
  && ! grep -q '\[--batch\]' "$GPG_LOG" && ! grep -q '\[--passphrase\]' "$GPG_LOG"; then
  pass "generate with a passphrase leaves the secret to the pinentry and adds an encryption subkey"
else
  fail "generate with passphrase did not follow the pinentry path: $(cat "$GPG_LOG")"
fi

# 5. rsa4096 gets an rsa4096 encryption subkey.
reset_case
run_gpg generate 'Dan <dan@example.com>' --algo rsa4096 --expire 0 >/dev/null 2>&1
if grep -q '\[--quick-add-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[rsa4096\] \[encr\] \[0\]' "$GPG_LOG"; then
  pass "generate --algo rsa4096 adds an rsa4096 encryption subkey"
else
  fail "rsa4096 subkey not added: $(cat "$GPG_LOG")"
fi

# 6. --no-passphrase without --yes is refused, and gpg is not called.
reset_case
status=0
run_gpg generate 'Eve <eve@example.com>' --no-passphrase >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ]; then
  pass "--no-passphrase needs --yes before gpg runs"
else
  fail "--no-passphrase ran without confirmation (status $status)"
fi

# 7. With --yes, the empty passphrase is passed in loopback mode, and the
# subkey step receives the same empty passphrase.
reset_case
run_gpg generate 'Eve <eve@example.com>' --no-passphrase --yes >/dev/null 2>&1
if grep -q '\[--batch\] \[--pinentry-mode\] \[loopback\] \[--passphrase\] \[\] \[--status-fd\] \[1\] \[--quick-gen-key\]' "$GPG_LOG" \
  && grep -q '\[--batch\] \[--pinentry-mode\] \[loopback\] \[--passphrase\] \[\] \[--quick-add-key\]' "$GPG_LOG"; then
  pass "--no-passphrase --yes uses loopback with an empty passphrase for both steps"
else
  fail "--no-passphrase --yes arguments unexpected: $(cat "$GPG_LOG")"
fi

# 8. A failed generation reports an error and never claims success.
reset_case
touch "$FAKE/gen-fail"
status=0
out="$(run_gpg generate 'Frank <frank@example.com>' 2>&1)" || status=$?
rm -f "$FAKE/gen-fail"
if [ "$status" -ne 0 ] && printf '%s' "$out" | grep -q 'error.gpg_generate_failed'; then
  pass "a failed generation exits non-zero with the error message"
else
  fail "failed generation not reported (status $status): $out"
fi

# 9. A subkey failure is reported with the fingerprint of the key that exists.
reset_case
touch "$FAKE/sub-fail"
status=0
out="$(run_gpg generate 'Grace <grace@example.com>' 2>&1)" || status=$?
rm -f "$FAKE/sub-fail"
if [ "$status" -ne 0 ] && printf '%s' "$out" | grep -q 'error.gpg_subkey_failed'; then
  pass "a subkey failure is reported and exits non-zero"
else
  fail "subkey failure not reported (status $status): $out"
fi

# 10. export-public writes the armored key with mode 600.
reset_case
dest="$WORK/alice.asc"
run_gpg export-public alice@example.com "$dest" >/dev/null 2>&1
mode="$(stat -c %a "$dest" 2>/dev/null || true)"
if grep -q 'BEGIN PGP PUBLIC KEY BLOCK' "$dest" && [ "$mode" = 600 ]; then
  pass "export-public writes the public key with mode 600"
else
  fail "export-public output unexpected (mode $mode)"
fi

# 11. An existing file is not replaced without --force, and --force replaces it.
reset_case
printf 'keep\n' > "$dest"
status=0
run_gpg export-public alice@example.com "$dest" >/dev/null 2>&1 || status=$?
kept="$(cat "$dest")"
run_gpg export-public alice@example.com "$dest" --force >/dev/null 2>&1
if [ "$status" -ne 0 ] && [ "$kept" = keep ] && grep -q 'BEGIN PGP PUBLIC KEY BLOCK' "$dest"; then
  pass "export-public refuses to overwrite without --force and replaces with --force"
else
  fail "export-public overwrite rules broken (status $status)"
fi

# 12. An id that matches no key leaves no file behind.
reset_case
nokey="$WORK/nokey.asc"
status=0
out="$(run_gpg export-public nobody@example.com "$nokey" 2>&1)" || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$nokey" ] && printf '%s' "$out" | grep -q 'error.gpg_no_key'; then
  pass "export-public with no matching key writes nothing"
else
  fail "export-public wrote a file for an unknown key (status $status)"
fi

# 13. An id that starts with a dash is refused.
reset_case
status=0
run_gpg export-public -- "$WORK/dash.asc" >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$WORK/dash.asc" ]; then
  pass "export-public refuses an id that starts with a dash"
else
  fail "export-public accepted a dash id"
fi

# 14. import of a public key file reaches gpg --import.
reset_case
pubfile="$WORK/public.asc"
printf -- '-----BEGIN PGP PUBLIC KEY BLOCK-----\nfake\n' > "$pubfile"
run_gpg import "$pubfile" >/dev/null 2>&1
if grep -q '\[--import\]' "$GPG_LOG"; then
  pass "import passes a public key file to gpg"
else
  fail "import did not call gpg --import: $(cat "$GPG_LOG")"
fi

# 15. import refuses a file with a secret key packet, and gpg does not import it.
reset_case
secfile="$WORK/secret.asc"
printf 'SECRET material\n' > "$secfile"
status=0
out="$(run_gpg import "$secfile" 2>&1)" || status=$?
if [ "$status" -ne 0 ] && ! grep -q '\[--import\]' "$GPG_LOG" && printf '%s' "$out" | grep -q 'error.gpg_private_refused'; then
  pass "import refuses a file that contains a private key"
else
  fail "import accepted a private key file (status $status)"
fi

# 16. status reports the default pinentry when there is no gpg-agent.conf.
reset_case
out="$(run_gpg status 2>&1)"
if printf '%s\n' "$out" | grep -Fxq $'gnupg\tyes' && printf '%s\n' "$out" | grep -Fxq $'pinentry\tnone\tdefault'; then
  pass "status reports the default pinentry without a configuration"
else
  fail "status without configuration unexpected: $out"
fi

# 17. set-pinentry without --yes is refused and creates no configuration.
reset_case
status=0
run_gpg set-pinentry qt >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$GNUPG/gpg-agent.conf" ]; then
  pass "set-pinentry needs --yes before it writes gpg-agent.conf"
else
  fail "set-pinentry wrote without confirmation (status $status)"
fi

# 18. set-pinentry qt writes the managed block with mode 600 and restarts the agent.
reset_case
run_gpg set-pinentry qt --yes >/dev/null 2>&1
conf="$GNUPG/gpg-agent.conf"
mode="$(stat -c %a "$conf" 2>/dev/null || true)"
if grep -Fxq "pinentry-program $FAKEBIN/pinentry-qt" "$conf" && [ "$mode" = 600 ] \
  && grep -q 'gpgconf --kill gpg-agent' "$GPGCONF_LOG"; then
  pass "set-pinentry qt writes the managed block with mode 600 and restarts gpg-agent"
else
  fail "set-pinentry qt result unexpected (mode $mode): $(cat "$conf" 2>/dev/null)"
fi

# 19. The user's own lines survive, the managed block is replaced rather than
# duplicated, and the previous file is kept as .bak.
reset_case
printf 'default-cache-ttl 600\n' > "$conf"
run_gpg set-pinentry qt --yes >/dev/null 2>&1
run_gpg set-pinentry qt --yes >/dev/null 2>&1
blocks="$(grep -c '^# BEGIN argvus-managed pinentry$' "$conf")"
if grep -Fxq 'default-cache-ttl 600' "$conf" && [ "$blocks" -eq 1 ] && [ -f "$conf.bak" ]; then
  pass "set-pinentry keeps the user's lines and replaces its own block"
else
  fail "set-pinentry changed the user's file wrongly (blocks $blocks)"
fi

# 20. A pinentry-program line the user wrote outside the block is refused, and
# the file is left as it was.
reset_case
printf 'pinentry-program /usr/bin/pinentry-gtk-2\n' > "$conf"
before="$(cat "$conf")"
status=0
run_gpg set-pinentry qt --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ "$(cat "$conf")" = "$before" ]; then
  pass "set-pinentry refuses to choose over a pinentry-program line the user wrote"
else
  fail "set-pinentry overrode the user's pinentry line (status $status)"
fi

# 21. status reports an ARGVUS-managed pinentry after set-pinentry.
reset_case
run_gpg set-pinentry qt --yes >/dev/null 2>&1
out="$(run_gpg status 2>&1)"
if printf '%s\n' "$out" | grep -Fxq $'pinentry\t'"$FAKEBIN"$'/pinentry-qt\targvus'; then
  pass "status reports the ARGVUS-managed pinentry"
else
  fail "status after set-pinentry unexpected: $out"
fi

# 22. A pinentry that is not installed is refused.
reset_case
status=0
run_gpg set-pinentry curses --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -e "$conf" ]; then
  pass "set-pinentry refuses a pinentry that is not installed"
else
  fail "set-pinentry accepted a missing pinentry (status $status)"
fi

# 23. No arguments print the help text.
reset_case
out="$(run_gpg 2>&1)"
if [ "$out" = help.gpg ]; then
  pass "no arguments prints the help text"
else
  fail "help output unexpected: $out"
fi

[ "$failures" -ne 0 ] && { printf '%s failure(s)\n' "$failures" >&2; exit 1; }
printf 'argvus-gpg tests ok\n'
