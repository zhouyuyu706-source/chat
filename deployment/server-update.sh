#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
website_root="/data/zova/website"
names_root="/data/zova/deploy-names"
backup_root="/data/zova/backups"
lock_file="/run/lock/zova-deploy.lock"
commit="$(git -C "$repo_root" rev-parse --verify HEAD)"
stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$backup_root/git-deploy-$stamp-${commit:0:12}"

exec 9>"$lock_file"
flock -n 9 || { echo "Another Zova deployment is running" >&2; exit 1; }

test -f "$repo_root/website/public/index.html"
test -d "$repo_root/website/public/assets"
test -f "$repo_root/deployment/nameservice/app.py"
mkdir -p "$website_root/assets" "$names_root" "$backup_dir"

if [[ -f "$website_root/index.html" ]]; then
  cp -a "$website_root/index.html" "$backup_dir/index.html"
fi
if [[ -f "$names_root/app.py" ]]; then
  cp -a "$names_root/app.py" "$backup_dir/app.py"
fi

install -m 0644 "$repo_root/website/public/index.html" "$website_root/index.html.new"
mv -f "$website_root/index.html.new" "$website_root/index.html"
cp -a "$repo_root/website/public/assets/." "$website_root/assets/"

names_changed=0
for file in app.py backup.py; do
  if [[ -f "$repo_root/deployment/nameservice/$file" ]]; then
    if [[ ! -f "$names_root/$file" ]] || ! cmp -s "$repo_root/deployment/nameservice/$file" "$names_root/$file"; then
      install -m 0644 "$repo_root/deployment/nameservice/$file" "$names_root/$file"
      names_changed=1
    fi
  fi
done

if [[ "$names_changed" -eq 1 ]]; then
  systemctl restart zova-names.service
  systemctl is-active --quiet zova-names.service
fi

printf '%s\n' "$commit" > "$website_root/DEPLOYED_COMMIT.new"
mv -f "$website_root/DEPLOYED_COMMIT.new" "$website_root/DEPLOYED_COMMIT"

/www/server/nginx/sbin/nginx -t
curl --fail --silent --show-error --max-time 15 https://zova.38-60-203-167.sslip.io/ >/dev/null
echo "Deployed Zova commit $commit"
