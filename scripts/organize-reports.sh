#!/bin/bash
# organize-reports.sh
# Organizes test reports into timestamped folders for Docker build

set -e

REPORTS_DIR="${1:-reports}"
PLAYWRIGHT_SOURCE="${2:-tester/playwright-report}"
ALLURE_SOURCE="${3:-tester/allure-report}"
REPORT_TIMESTAMP="${4:-$(date +%Y-%m-%d_%H-%M-%S)}"

echo "Report timestamp: $REPORT_TIMESTAMP"

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Copy new reports to timestamped folder
echo "Creating timestamped report: $REPORT_TIMESTAMP"
mkdir -p "${REPORTS_DIR}/${REPORT_TIMESTAMP}"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/${REPORT_TIMESTAMP}/"
mkdir -p "${REPORTS_DIR}/${REPORT_TIMESTAMP}/allure"
cp -r "${ALLURE_SOURCE}"/* "${REPORTS_DIR}/${REPORT_TIMESTAMP}/allure/"

# Copy to latest (overwrite)
echo "Updating latest report..."
rm -rf "${REPORTS_DIR}/latest"
mkdir -p "${REPORTS_DIR}/latest"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/latest/"
mkdir -p "${REPORTS_DIR}/latest/allure"
cp -r "${ALLURE_SOURCE}"/* "${REPORTS_DIR}/latest/allure/"

# Generate reports index
ls -1 "$REPORTS_DIR" | sort -r > "${REPORTS_DIR}/reports-index.json.tmp"
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
