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

# A passphrase read from file descriptor 0 is recorded apart from the log, so
# a test can check that it arrived on stdin and never in an argument.
for a in "$@"; do
  if [ "$a" = --passphrase-fd ]; then
    IFS= read -r passphrase_line || passphrase_line=''
    printf '%s\n' "$passphrase_line" >> "$FAKE_DIR/stdin.log"
  fi
done

cmd=''
for a in "$@"; do
  case "$a" in
    --list-secret-keys|--list-keys|--list-packets|--quick-gen-key|--quick-add-key|--export|--import)
      cmd=$a ;;
    --export-secret-keys|--delete-secret-and-public-key|--delete-keys|--quick-set-expire|--quick-sign-key|--change-passphrase|--edit-key|--send-keys|--recv-keys)
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
  --export-secret-keys)
    printf -- '-----BEGIN PGP PRIVATE KEY BLOCK-----\nfake\n-----END PGP PRIVATE KEY BLOCK-----\n'
    ;;
  --edit-key)
    # The answers the launcher sends on stdin are recorded for the test.
    cat > "$FAKE_DIR/edit.log"
    ;;
  --delete-secret-and-public-key|--delete-keys|--quick-set-expire|--quick-sign-key|--change-passphrase|--send-keys|--recv-keys)
    ;;
esac
exit 0
EOF

# Fake gpgconf: logs the call only.
cat > "$FAKEBIN/gpgconf" <<'EOF'
#!/bin/sh
printf 'gpgconf %s\n' "$*" >> "$TEST_GPGCONF_LOG"
EOF

# Fake pinentry program. ARGVUS always uses pinentry-gtk.
cat > "$FAKEBIN/pinentry-gtk" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod 755 "$FAKEBIN/gpg" "$FAKEBIN/gpgconf" "$FAKEBIN/pinentry-gtk"

# Runs argvus-gpg in isolation with the given arguments.
# Runs argvus-gpg in isolation with the given arguments. Its stdin is the file
# named by TEST_STDIN when that is set, and /dev/null otherwise.
run_gpg() {
  env -i PATH="$TOOLS:$FAKEBIN" HOME="$WORK/home" GNUPGHOME="$GNUPG" \
    ARGVUS_SYSTEM_CONFIG="$SYSTEM" ARGVUS_BOOTSTRAP=/nonexistent \
    FAKE_DIR="$FAKE" TEST_GPG_LOG="$GPG_LOG" TEST_GPGCONF_LOG="$GPGCONF_LOG" \
    timeout 20 sh "$BIN_DIR/argvus-gpg" "$@" <"${TEST_STDIN:-/dev/null}"
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
  rm -f "$FAKE/stdin.log" "$FAKE/edit.log"
  unset TEST_STDIN
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
run_gpg generate 'Name' --algo ed25519 >/dev/null 2>&1 || true
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
if grep -q '\[--quick-gen-key\] \[Carol <carol@example.com>\] \[rsa4096\] \[default\] \[2y\]' "$GPG_LOG" \
  && grep -q '\[--quick-add-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[rsa4096\] \[encr\] \[2y\]' "$GPG_LOG" \
  && ! grep -q '\[--batch\]' "$GPG_LOG" && ! grep -q '\[--passphrase\]' "$GPG_LOG"; then
  pass "generate with a passphrase leaves the secret to the pinentry and adds an encryption subkey"
else
  fail "generate with passphrase did not follow the pinentry path: $(cat "$GPG_LOG")"
fi

# 5. DSA gets a 2048-bit DSA primary key and a 2048-bit ElGamal encryption
# subkey, which is the pairing the DSA standard requires.
reset_case
run_gpg generate 'Dan <dan@example.com>' --algo dsa --expire 0 >/dev/null 2>&1
if grep -q '\[--quick-gen-key\] \[Dan <dan@example.com>\] \[dsa2048\] \[default\] \[0\]' "$GPG_LOG" \
  && grep -q '\[--quick-add-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[elg2048\] \[encr\] \[0\]' "$GPG_LOG"; then
  pass "generate --algo dsa uses dsa2048 with an elg2048 encryption subkey"
else
  fail "dsa generation arguments unexpected: $(cat "$GPG_LOG")"
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

# 16b. status reports the command set version first, so the Control Center can
# tell an older launcher from a current one.
reset_case
out="$(run_gpg status 2>&1)"
if [ "$(printf '%s\n' "$out" | head -n 1)" = "$(printf 'api\t2')" ]; then
  pass "status reports the command set version as its first line"
else
  fail "status first line is not the api version: $out"
fi

# 17. generate writes the ARGVUS block with pinentry-gtk, mode 600, and restarts
# gpg-agent so the new pinentry is used.
reset_case
run_gpg generate 'Hank <hank@example.com>' --expire 0 >/dev/null 2>&1
conf="$GNUPG/gpg-agent.conf"
mode="$(stat -c %a "$conf" 2>/dev/null || true)"
if grep -Fxq "pinentry-program $FAKEBIN/pinentry-gtk" "$conf" && [ "$mode" = 600 ] \
  && grep -q 'gpgconf --kill gpg-agent' "$GPGCONF_LOG"; then
  pass "generate writes the pinentry-gtk block with mode 600 and restarts gpg-agent"
else
  fail "pinentry-gtk block unexpected (mode $mode): $(cat "$conf" 2>/dev/null)"
fi

# 18. The user's own lines survive, the block is replaced rather than duplicated,
# the previous file is kept as .bak, and a second generate leaves an up-to-date
# block alone instead of restarting gpg-agent again.
reset_case
printf 'default-cache-ttl 600\n' > "$conf"
run_gpg generate 'Ivy <ivy@example.com>' >/dev/null 2>&1
: > "$GPGCONF_LOG"
run_gpg generate 'Ivy <ivy@example.com>' >/dev/null 2>&1
blocks="$(grep -c '^# BEGIN argvus-managed pinentry$' "$conf")"
if grep -Fxq 'default-cache-ttl 600' "$conf" && [ "$blocks" -eq 1 ] && [ -f "$conf.bak" ] \
  && [ ! -s "$GPGCONF_LOG" ]; then
  pass "generate keeps the user's lines, keeps one block, and skips the restart when nothing changed"
else
  fail "generate changed the user's file wrongly (blocks $blocks)"
fi

# 19. A pinentry-program line the user wrote outside the block is refused before
# gpg runs, and the file is left as it was.
reset_case
printf 'pinentry-program /usr/bin/pinentry-curses\n' > "$conf"
before="$(cat "$conf")"
status=0
run_gpg generate 'Judy <judy@example.com>' >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ "$(cat "$conf")" = "$before" ] && ! grep -q 'quick-gen-key' "$GPG_LOG"; then
  pass "generate refuses to choose over a pinentry-program line the user wrote"
else
  fail "generate overrode the user's pinentry line (status $status)"
fi

# 20. status reports the ARGVUS-managed pinentry after generate.
reset_case
run_gpg generate 'Kim <kim@example.com>' >/dev/null 2>&1
out="$(run_gpg status 2>&1)"
if printf '%s\n' "$out" | grep -Fxq $'pinentry\t'"$FAKEBIN"$'/pinentry-gtk\targvus'; then
  pass "status reports the ARGVUS-managed pinentry"
else
  fail "status after generate unexpected: $out"
fi

# 21. A missing pinentry-gtk is refused before gpg runs, and nothing is written.
reset_case
mv "$FAKEBIN/pinentry-gtk" "$WORK/pinentry-gtk.off"
status=0
out="$(run_gpg generate 'Leo <leo@example.com>' 2>&1)" || status=$?
mv "$WORK/pinentry-gtk.off" "$FAKEBIN/pinentry-gtk"
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ] && [ ! -e "$conf" ] \
  && printf '%s' "$out" | grep -q 'error.gpg_pinentry_missing'; then
  pass "generate refuses to run when pinentry-gtk is not installed"
else
  fail "generate accepted a missing pinentry-gtk (status $status): $out"
fi

# 22. DSA above 3072 bits is refused before gpg runs, because gpg cannot create it.
reset_case
status=0
out="$(run_gpg generate 'Mona <mona@example.com>' --algo dsa --bits 4096 2>&1)" || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ] && printf '%s' "$out" | grep -q 'error.gpg_bad_bits'; then
  pass "generate refuses a DSA key above 3072 bits before calling gpg"
else
  fail "generate accepted dsa4096 (status $status): $out"
fi

# 23. An expiry given as an ISO date is passed to gpg unchanged.
reset_case
run_gpg generate 'Nina <nina@example.com>' --expire 2031-06-30 >/dev/null 2>&1
if grep -q '\[--quick-gen-key\] \[Nina <nina@example.com>\] \[rsa4096\] \[default\] \[2031-06-30\]' "$GPG_LOG"; then
  pass "generate accepts an ISO expiry date and passes it to gpg"
else
  fail "ISO expiry not passed to gpg: $(cat "$GPG_LOG")"
fi

# 24. A passphrase on stdin reaches gpg on file descriptor 0, and never appears
# in an argument of any gpg call.
reset_case
printf 'correct horse\n' > "$WORK/stdin.txt"
TEST_STDIN="$WORK/stdin.txt" run_gpg generate 'Oscar <oscar@example.com>' --expire 0 --passphrase-stdin >/dev/null 2>&1
if grep -q '^correct horse$' "$FAKE/stdin.log" 2>/dev/null \
  && ! grep -q 'correct horse' "$GPG_LOG" \
  && grep -q '\[--passphrase-fd\] \[0\] \[--status-fd\] \[1\] \[--quick-gen-key\]' "$GPG_LOG" \
  && ! grep -q '\[--passphrase\] \[' "$GPG_LOG"; then
  pass "a passphrase on stdin reaches gpg on fd 0 and never in an argument"
else
  fail "passphrase on stdin handled wrongly: $(cat "$GPG_LOG")"
fi

# 25. An empty passphrase on stdin is refused before gpg runs.
reset_case
printf '\n' > "$WORK/stdin.txt"
status=0
out="$(TEST_STDIN="$WORK/stdin.txt" run_gpg generate 'Pat <pat@example.com>' --passphrase-stdin 2>&1)" || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ] && printf '%s' "$out" | grep -q 'error.gpg_passphrase_empty'; then
  pass "an empty passphrase on stdin is refused before gpg runs"
else
  fail "empty passphrase accepted (status $status): $out"
fi

# 26. --passphrase-stdin cannot be combined with --no-passphrase.
reset_case
status=0
run_gpg generate 'Quinn <quinn@example.com>' --passphrase-stdin --no-passphrase --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ]; then
  pass "--passphrase-stdin and --no-passphrase are refused together"
else
  fail "the two passphrase modes were combined (status $status)"
fi

# 28. export-private refuses without --yes, and gpg does not run.
reset_case
status=0
run_gpg export-private AAAA111122223333AAAA111122223333AAAAAAAA "$WORK/priv.asc" >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && ! grep -q 'export-secret-keys' "$GPG_LOG" && [ ! -e "$WORK/priv.asc" ]; then
  pass "export-private needs --yes before gpg runs"
else
  fail "export-private ran without --yes (status $status)"
fi

# 29. export-private with --yes writes the armored secret key with mode 600.
reset_case
dest="$WORK/priv.asc"
run_gpg export-private AAAA111122223333AAAA111122223333AAAAAAAA "$dest" --yes >/dev/null 2>&1
mode="$(stat -c %a "$dest" 2>/dev/null || true)"
if grep -q 'PRIVATE KEY BLOCK' "$dest" && [ "$mode" = 600 ] && grep -q '\[--no-tty\]' "$GPG_LOG"; then
  pass "export-private writes the secret key with mode 600 and never uses a terminal"
else
  fail "export-private output unexpected (mode $mode): $(cat "$GPG_LOG")"
fi

# 30. A short id is refused for secret-key commands, before gpg runs.
reset_case
status=0
run_gpg export-private alice@example.com "$WORK/short.asc" --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ] && [ ! -e "$WORK/short.asc" ]; then
  pass "secret-key commands refuse a short id"
else
  fail "a short id reached gpg (status $status)"
fi

# 31. export-private does not replace an existing file without --force.
reset_case
printf 'keep\n' > "$WORK/priv-keep.asc"
status=0
run_gpg export-private AAAA111122223333AAAA111122223333AAAAAAAA "$WORK/priv-keep.asc" --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ "$(cat "$WORK/priv-keep.asc")" = keep ]; then
  pass "export-private refuses to overwrite without --force"
else
  fail "export-private overwrote a file (status $status)"
fi

# 32. import-private refuses a file without a secret key packet.
reset_case
pubonly="$WORK/pub-only.asc"
printf -- '-----BEGIN PGP PUBLIC KEY BLOCK-----\nfake\n' > "$pubonly"
status=0
out="$(run_gpg import-private "$pubonly" 2>&1)" || status=$?
if [ "$status" -ne 0 ] && ! grep -q '\[--import\]' "$GPG_LOG" && printf '%s' "$out" | grep -q 'error.gpg_not_private'; then
  pass "import-private refuses a file without a private key"
else
  fail "import-private accepted a public-only file (status $status)"
fi

# 33. import-private passes a private key file to gpg --import.
reset_case
secfile="$WORK/secret-import.asc"
printf 'SECRET material\n' > "$secfile"
run_gpg import-private "$secfile" >/dev/null 2>&1
if grep -q '\[--import\]' "$GPG_LOG"; then
  pass "import-private imports a private key file"
else
  fail "import-private did not import: $(cat "$GPG_LOG")"
fi

# 34. delete needs --yes, and a full fingerprint.
reset_case
status=0
run_gpg delete AAAA111122223333AAAA111122223333AAAAAAAA >/dev/null 2>&1 || status=$?
short=0
run_gpg delete AAAA111122223333 --yes >/dev/null 2>&1 || short=$?
if [ "$status" -ne 0 ] && [ "$short" -ne 0 ] && [ ! -s "$GPG_LOG" ]; then
  pass "delete needs --yes and a full fingerprint before gpg runs"
else
  fail "delete ran without confirmation or with a short id"
fi

# 35. delete of a key with a secret part removes both halves.
reset_case
run_gpg delete AAAA111122223333AAAA111122223333AAAAAAAA --yes >/dev/null 2>&1
if grep -q '\[--delete-secret-and-public-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\]' "$GPG_LOG"; then
  pass "delete removes a key with its secret part"
else
  fail "delete arguments unexpected: $(cat "$GPG_LOG")"
fi

# 36. edit expire sets the primary key, then each subkey by its fingerprint.
reset_case
run_gpg edit expire AAAA111122223333AAAA111122223333AAAAAAAA 2031-06-30 >/dev/null 2>&1
if grep -q '\[--quick-set-expire\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[2031-06-30\]' "$GPG_LOG" \
  && grep -q '\[--quick-set-expire\] \[AAAA111122223333AAAA111122223333AAAAAAAA\] \[2031-06-30\] \[BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\]' "$GPG_LOG"; then
  pass "edit expire sets the primary key and each subkey"
else
  fail "edit expire arguments unexpected: $(cat "$GPG_LOG")"
fi

# 37. edit expire refuses an invalid expiry before gpg runs.
reset_case
status=0
run_gpg edit expire AAAA111122223333AAAA111122223333AAAAAAAA soon >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ]; then
  pass "edit expire refuses an invalid expiry"
else
  fail "edit expire accepted an invalid expiry (status $status)"
fi

# 38. edit revoke answers the revocation dialog: revoke, reason number, empty
# description, save. An unknown reason is refused.
reset_case
run_gpg edit revoke AAAA111122223333AAAA111122223333AAAAAAAA --reason unused --yes >/dev/null 2>&1
if [ "$(cat "$FAKE/edit.log" 2>/dev/null)" = "$(printf 'revkey\ny\n3\n\ny\nsave')" ] \
  && grep -q '\[--edit-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\]' "$GPG_LOG"; then
  pass "edit revoke answers the revocation dialog with the chosen reason"
else
  fail "revocation answers unexpected: $(cat "$FAKE/edit.log" 2>/dev/null)"
fi
reset_case
status=0
run_gpg edit revoke AAAA111122223333AAAA111122223333AAAAAAAA --reason bored --yes >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && [ ! -s "$GPG_LOG" ]; then
  pass "edit revoke refuses an unknown reason"
else
  fail "edit revoke accepted an unknown reason"
fi

# 39. edit trust answers the trust menu; ultimate gets its extra confirmation.
reset_case
run_gpg edit trust AAAA111122223333AAAA111122223333AAAAAAAA full >/dev/null 2>&1
full_answers="$(cat "$FAKE/edit.log" 2>/dev/null)"
run_gpg edit trust AAAA111122223333AAAA111122223333AAAAAAAA ultimate >/dev/null 2>&1
ultimate_answers="$(cat "$FAKE/edit.log" 2>/dev/null)"
if [ "$full_answers" = "$(printf 'trust\n4\nquit')" ] && [ "$ultimate_answers" = "$(printf 'trust\n5\ny\nquit')" ]; then
  pass "edit trust answers the trust menu, with the ultimate confirmation"
else
  fail "trust answers unexpected: [$full_answers] [$ultimate_answers]"
fi

# 40. edit sign certifies with the signer's secret key, and needs --yes.
reset_case
status=0
run_gpg edit sign AAAA111122223333AAAA111122223333AAAAAAAA CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEE >/dev/null 2>&1 || status=$?
no_yes_calls="$(grep -c 'quick-sign-key' "$GPG_LOG" || true)"
reset_case
run_gpg edit sign AAAA111122223333AAAA111122223333AAAAAAAA CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEE --yes >/dev/null 2>&1
if [ "$status" -ne 0 ] && [ "$no_yes_calls" -eq 0 ] \
  && grep -q '\[--local-user\] \[CCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDEEEEEEEE\] .*\[--quick-sign-key\] \[AAAA111122223333AAAA111122223333AAAAAAAA\]' "$GPG_LOG"; then
  pass "edit sign needs --yes and certifies with the chosen signer"
else
  fail "edit sign unexpected (status $status): $(cat "$GPG_LOG")"
fi

# 41. edit passwd only asks gpg to change the passphrase; no passphrase is an argument.
reset_case
run_gpg edit passwd AAAA111122223333AAAA111122223333AAAAAAAA >/dev/null 2>&1
if grep -q '\[--change-passphrase\] \[AAAA111122223333AAAA111122223333AAAAAAAA\]' "$GPG_LOG" && ! grep -q '\[--passphrase\]' "$GPG_LOG"; then
  pass "edit passwd delegates the change to the pinentry"
else
  fail "edit passwd arguments unexpected: $(cat "$GPG_LOG")"
fi

# 42. keyserver send publishes only with --yes; recv fetches without it.
reset_case
status=0
run_gpg keyserver send AAAA111122223333AAAA111122223333AAAAAAAA >/dev/null 2>&1 || status=$?
if [ "$status" -ne 0 ] && ! grep -q 'send-keys' "$GPG_LOG"; then
  pass "keyserver send needs --yes before it publishes"
else
  fail "keyserver send published without --yes"
fi
reset_case
run_gpg keyserver recv AAAA111122223333AAAA111122223333AAAAAAAA >/dev/null 2>&1
if grep -q '\[--recv-keys\] \[AAAA111122223333AAAA111122223333AAAAAAAA\]' "$GPG_LOG"; then
  pass "keyserver recv fetches the key by fingerprint"
else
  fail "keyserver recv arguments unexpected: $(cat "$GPG_LOG")"
fi

# 43. export-public with - writes the armored public key to standard output.
reset_case
out="$(run_gpg export-public alice@example.com - 2>/dev/null)"
if printf '%s' "$out" | grep -q 'BEGIN PGP PUBLIC KEY BLOCK' && [ ! -e "$WORK/-" ]; then
  pass "export-public with - prints the public key to standard output"
else
  fail "export-public - output unexpected: $out"
fi

# 44. No arguments print the help text.
reset_case
out="$(run_gpg 2>&1)"
if [ "$out" = help.gpg ]; then
  pass "no arguments prints the help text"
else
  fail "help output unexpected: $out"
fi

[ "$failures" -ne 0 ] && { printf '%s failure(s)\n' "$failures" >&2; exit 1; }
printf 'argvus-gpg tests ok\n'
