#!/usr/bin/env bash
set -euo pipefail
APK=${1:?Provide the signed APK}
TOOLS=/opt/zova-android-sdk/build-tools/30.0.3
test -s "$APK"
"$TOOLS/apksigner" verify --verbose --print-certs "$APK"
"$TOOLS/zipalign" -c -p 4 "$APK"
metadata=$("$TOOLS/aapt" dump badging "$APK")
printf '%s\n' "$metadata" | grep -F "package: name='io.github.zhoyu1910_ship_it.zova'"
printf '%s\n' "$metadata" | grep -F "application-label:'Zova'"
printf '%s\n' "$metadata" | grep -F "native-code: 'arm64-v8a'"
unzip -l "$APK" | grep -F 'lib/arm64-v8a/libring.so'
unzip -l "$APK" | grep -F 'lib/arm64-v8a/libc++_shared.so'
size=$(unzip -p "$APK" lib/arm64-v8a/libring.so | wc -c)
test "$size" -gt 1000000
sha256sum "$APK"
echo 'APK package checks passed. This does not claim phone runtime testing.'
