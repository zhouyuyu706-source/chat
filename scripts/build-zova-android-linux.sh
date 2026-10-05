#!/usr/bin/env bash
set -euo pipefail
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export ANDROID_HOME=/opt/zova-android-sdk
export ANDROID_SDK="$ANDROID_HOME"
export ANDROID_NDK="$ANDROID_HOME/ndk/23.1.7779620"
export ANDROID_NDK_ROOT="$ANDROID_NDK"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
export ANDROID_ABI='arm64-v8a'
export ZOVA_BUILD_JOBS=8
export DAEMON_DIR=/opt/zova-src/daemon
cd /opt/zova-src/client-android
bash compile.sh --daemon --release
cd ring-android
bash gradlew --no-daemon --max-workers=4 -Parchs=arm64-v8a assembleNoPushRelease
echo 'Native ARM64 release APK built; signing and APK verification are separate release gates.'
