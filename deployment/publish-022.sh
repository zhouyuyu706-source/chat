#!/usr/bin/env bash
set -euo pipefail
cd /data/zova
test "$(sha256sum Zova-0.2.2-source-complete.tar.gz | cut -d ' ' -f1)" = adb80a0bfc96bb534d23d0ffea618c5db079a732ebb9ecce198e44b25bfb773b
gzip -t Zova-0.2.2-source-complete.tar.gz
test ! -e website/downloads/Zova-0.2.2-source-complete.tar.gz
mv Zova-0.2.2-source-complete.tar.gz website/downloads/
cd website/downloads
sha256sum -c /data/zova/SHA256SUMS-0.2.2.txt
cd /data/zova
cp -p website/index.html "index-before-022-$(date +%Y%m%d%H%M%S).html"
install -m 644 SHA256SUMS-0.2.2.txt website/downloads/SHA256SUMS-0.2.2.txt
install -m 644 index-022.html website/index-022.tmp
mv website/index-022.tmp website/index.html
echo 'Published Zova 0.2.2 download page after all release hashes matched.'
