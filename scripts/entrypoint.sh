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
    rm -rf "${REPORTS_DIR:?}/${dirname:?}"
    cp -r "$dir" "${REPORTS_DIR}/${dirname}"
  done

  # Copy index file
  [ -f "$STAGING_DIR/reports-index.json" ] && cp "$STAGING_DIR/reports-index.json" "$REPORTS_DIR/"
fi

# Clean up reports older than retention period
echo "Cleaning reports older than $RETENTION_DAYS days..."
# Calculate cutoff using seconds (works with BusyBox)
CUTOFF_SECONDS=$(($(date +%s) - RETENTION_DAYS * 86400))
CUTOFF=$(date -d "@$CUTOFF_SECONDS" +%Y-%m-%d_%H-%M-%S)
for dir in "${REPORTS_DIR}"/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  # Skip 'latest_*' folders and match timestamp_env pattern (e.g., 2026-01-29_14-30-00_functionaltest)
  if ! echo "$dirname" | grep -qE '^latest_' && echo "$dirname" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}_'; then
    # Extract timestamp part for comparison (first 19 chars: YYYY-MM-DD_HH-MM-SS)
    timestamp_part=$(echo "$dirname" | cut -c1-19)
    # Use case statement for POSIX-compatible string comparison
    if [ "$(printf '%s\n%s' "$timestamp_part" "$CUTOFF" | sort | head -1)" = "$timestamp_part" ] && [ "$timestamp_part" != "$CUTOFF" ]; then
      echo "  Removing old report: $dirname"
      rm -rf "$dir"
    fi
  fi
done

# Update reports index
echo "Updating reports index..."
# Use find instead of ls | grep for better handling of filenames
find "$REPORTS_DIR" -maxdepth 1 -type d \( -name '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_*' -o -name 'latest_*' \) -printf '%f\n' | sort -r > /tmp/dirs.txt
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
