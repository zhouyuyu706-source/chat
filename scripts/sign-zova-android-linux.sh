#!/usr/bin/env bash
set -euo pipefail
umask 077
KEYDIR=/opt/zova-signing
KEYSTORE="$KEYDIR/zova-release.jks"
PASSFILE="$KEYDIR/password.txt"
mkdir -p "$KEYDIR"
chmod 700 "$KEYDIR"
if [ ! -e "$KEYSTORE" ]; then
  if [ -e "$PASSFILE" ]; then echo 'Incomplete signing setup: preserve existing password and inspect manually.' >&2; exit 1; fi
  openssl rand -out "$PASSFILE" -hex 32
  /usr/lib/jvm/java-11-openjdk-amd64/bin/keytool -genkeypair -keystore "$KEYSTORE" -storetype JKS -alias zova-release -keyalg RSA -keysize 3072 -validity 10000 -dname 'CN=Zova' -storepass:file "$PASSFILE" -keypass:file "$PASSFILE"
fi
test -s "$KEYSTORE" && test -s "$PASSFILE"
if [ "${1:-}" = '--prepare-key-only' ]; then echo 'Local Android release key prepared; keep private and back it up before distribution.'; exit 0; fi
APK=${1:?Provide the actual unsigned APK path}
OUT=${2:?Provide a new signed APK output path}
test -f "$APK"
if [ -e "$OUT" ]; then echo 'Refusing to overwrite existing signed artifact.' >&2; exit 1; fi
TOOLS=/opt/zova-android-sdk/build-tools/30.0.3
"$TOOLS/zipalign" -f -p 4 "$APK" "$OUT.aligned"
# The key uses the store password. Reading the same password file twice makes
# apksigner consume the first line and then fail with EOF on the second read.
"$TOOLS/apksigner" sign --ks "$KEYSTORE" --ks-key-alias zova-release --ks-pass "file:$PASSFILE" --out "$OUT" "$OUT.aligned"
"$TOOLS/apksigner" verify --verbose --print-certs "$OUT"
"$TOOLS/zipalign" -c -p 4 "$OUT"
sha256sum "$OUT"
