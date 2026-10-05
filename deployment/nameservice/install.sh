#!/usr/bin/env bash
set -euo pipefail
test "$(id -u)" = 0
BASE=$(cd "$(dirname "$0")" && pwd)
test -f "$BASE/app.py"
id zova-names >/dev/null 2>&1 || useradd --system --home-dir /nonexistent --shell /usr/sbin/nologin zova-names
install -d -o root -g root -m 755 /opt/zova-names
install -d -o zova-names -g zova-names -m 700 /data/zova/names
install -m 644 "$BASE/app.py" /opt/zova-names/app.py
install -m 644 "$BASE/zova-names.service" /etc/systemd/system/zova-names.service
systemctl daemon-reload
systemctl enable --now zova-names
systemctl restart zova-names
CONFIG=/www/server/panel/vhost/nginx/zova.38-60-203-167.sslip.io.conf
BACKUP="$CONFIG.before-names-$(date +%Y%m%d%H%M%S)"
cp -p "$CONFIG" "$BACKUP"
install -m 644 "$BASE/website-https.conf" "$CONFIG"
if ! /www/server/nginx/sbin/nginx -t; then
    cp -p "$BACKUP" "$CONFIG"
    echo 'Nginx validation failed; restored prior configuration.' >&2
    exit 1
fi
/www/server/nginx/sbin/nginx -s reload
systemctl is-active zova-names
