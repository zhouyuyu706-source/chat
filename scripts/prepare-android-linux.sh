#!/usr/bin/env bash
set -euo pipefail
export ANDROID_HOME=/opt/zova-android-sdk
mkdir -p "$ANDROID_HOME/cmdline-tools" /opt/zova-downloads /opt/zova-src
if [ ! -x "$ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager" ]; then
  curl -fL --retry 3 https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -o /opt/zova-downloads/commandlinetools.zip
  unzip -q /opt/zova-downloads/commandlinetools.zip -d "$ANDROID_HOME/cmdline-tools"
  mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/tools"
fi
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
SDKMANAGER="$ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager"
# Accept SDK licences for this application build, without modifying other SDKs.
set +o pipefail
yes | "$SDKMANAGER" --sdk_root="$ANDROID_HOME" --licenses
license_status=${PIPESTATUS[1]}
set -o pipefail
test "$license_status" -eq 0
"$SDKMANAGER" --sdk_root="$ANDROID_HOME" 'platform-tools' 'platforms;android-30' 'build-tools;30.0.3' 'ndk;23.1.7779620'
for repo in daemon client-android; do
  mkdir -p "/opt/zova-src/$repo"
  rsync -a --exclude=.git --exclude=build --exclude=x64 --exclude=msvc --exclude=.gradle --exclude=unstripped --exclude='*.log' "/mnt/d/Liaodanwang/$repo/" "/opt/zova-src/$repo/"
done
find /opt/zova-src -type f \( -name '*.sh' -o -name '*.py' -o -name '*.mak' -o -name '*.ac' -o -name '*.am' -o -name '*.in' -o -name '*.patch' -o -name '*SUMS' -o -name bootstrap -o -name configure -o -name gradlew -o -name Makefile \) -exec sed -i 's/\r$//' {} +
echo 'Android build environment prepared; no APK has been built by this script.'
