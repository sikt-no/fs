#!/bin/sh
# organize-reports.sh
# Organizes test reports into timestamped folders for Docker build

set -e

REPORTS_DIR="${1:-reports}"
PLAYWRIGHT_SOURCE="${2:-tester/playwright-report}"
REPORT_TIMESTAMP="${3:-$(date +%Y-%m-%d_%H-%M-%S)}"
TEST_ENV="${4:-functionaltest}"

FOLDER_NAME="${REPORT_TIMESTAMP}_${TEST_ENV}"
LATEST_FOLDER="latest_${TEST_ENV}"

echo "Report timestamp: $REPORT_TIMESTAMP"
echo "Test environment: $TEST_ENV"
echo "Folder name: $FOLDER_NAME"

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Copy new reports to timestamped folder
echo "Creating timestamped report: $FOLDER_NAME"
mkdir -p "${REPORTS_DIR}/${FOLDER_NAME}/playwright"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/${FOLDER_NAME}/playwright/"

# Copy to latest_{env} (overwrite)
echo "Updating ${LATEST_FOLDER}..."
rm -rf "${REPORTS_DIR:?}/${LATEST_FOLDER:?}"
mkdir -p "${REPORTS_DIR}/${LATEST_FOLDER}/playwright"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/${LATEST_FOLDER}/playwright/"

# Generate reports index (BusyBox-compatible find without -printf)
find "$REPORTS_DIR" -maxdepth 1 -mindepth 1 -type d | sed 's|.*/||' | sort -r > "${REPORTS_DIR}/reports-index.json.tmp"
echo "[" > "${REPORTS_DIR}/reports-index.json"
first=true
while read -r dir; do
  [ -z "$dir" ] && continue
  if [ "$first" = true ]; then
    first=false
  else
    echo "," >> "${REPORTS_DIR}/reports-index.json"
  fi
  printf '  "%s"' "$dir" >> "${REPORTS_DIR}/reports-index.json"
done < "${REPORTS_DIR}/reports-index.json.tmp"
echo "" >> "${REPORTS_DIR}/reports-index.json"
echo "]" >> "${REPORTS_DIR}/reports-index.json"
rm "${REPORTS_DIR}/reports-index.json.tmp"

echo "Done! Reports organized in $REPORTS_DIR"
