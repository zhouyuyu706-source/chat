#!/bin/sh
set -eu
# Reload only after the entire existing Nginx configuration has passed validation.
/www/server/nginx/sbin/nginx -t
/www/server/nginx/sbin/nginx -s reload
