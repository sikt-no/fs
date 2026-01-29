#!/bin/sh
# entrypoint.sh
# Copies new reports to persistent volume and cleans up old ones

set -e

REPORTS_DIR="/usr/share/nginx/html"
STAGING_DIR="/reports-staging"
RETENTION_DAYS="${RETENTION_DAYS:-2}"

echo "Starting report deployment..."

# Copy new reports from staging to persistent volume
if [ -d "$STAGING_DIR" ]; then
  for dir in "$STAGING_DIR"/*/; do
    [ -d "$dir" ] || continue
    dirname=$(basename "$dir")
    echo "Deploying report: $dirname"
    rm -rf "${REPORTS_DIR}/${dirname}"
    cp -r "$dir" "${REPORTS_DIR}/${dirname}"
  done

  # Copy index file
  [ -f "$STAGING_DIR/reports-index.json" ] && cp "$STAGING_DIR/reports-index.json" "$REPORTS_DIR/"
fi

# Clean up reports older than retention period
echo "Cleaning reports older than $RETENTION_DAYS days..."
CUTOFF=$(date -d "${RETENTION_DAYS} days ago" +%Y-%m-%d_%H-%M-%S 2>/dev/null || date -v-${RETENTION_DAYS}d +%Y-%m-%d_%H-%M-%S)
for dir in "${REPORTS_DIR}"/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  # Skip 'latest' and any non-timestamp directories
  if [ "$dirname" != "latest" ] && echo "$dirname" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}_'; then
    if [ "$dirname" \< "$CUTOFF" ]; then
      echo "  Removing old report: $dirname"
      rm -rf "$dir"
    fi
  fi
done

# Update reports index
echo "Updating reports index..."
ls -1 "$REPORTS_DIR" 2>/dev/null | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}_|^latest$' | sort -r > /tmp/dirs.txt
if [ -s /tmp/dirs.txt ]; then
  # Create JSON array from directory list
  echo "[" > "${REPORTS_DIR}/reports-index.json"
  first=true
  while read -r dir; do
    if [ "$first" = true ]; then
      first=false
    else
      echo "," >> "${REPORTS_DIR}/reports-index.json"
    fi
    printf '  "%s"' "$dir" >> "${REPORTS_DIR}/reports-index.json"
  done < /tmp/dirs.txt
  echo "" >> "${REPORTS_DIR}/reports-index.json"
  echo "]" >> "${REPORTS_DIR}/reports-index.json"
fi

echo "Report deployment complete. Starting nginx..."

# Start nginx
exec nginx -g "daemon off;"
