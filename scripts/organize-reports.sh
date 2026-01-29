#!/bin/sh
# organize-reports.sh
# Organizes test reports into timestamped folders for Docker build

set -e

REPORTS_DIR="${1:-reports}"
PLAYWRIGHT_SOURCE="${2:-tester/playwright-report}"
ALLURE_SOURCE="${3:-tester/allure-report}"
REPORT_TIMESTAMP="${4:-$(date +%Y-%m-%d_%H-%M-%S)}"
TEST_ENV="${5:-functionaltest}"

FOLDER_NAME="${REPORT_TIMESTAMP}_${TEST_ENV}"
LATEST_FOLDER="latest_${TEST_ENV}"

echo "Report timestamp: $REPORT_TIMESTAMP"
echo "Test environment: $TEST_ENV"
echo "Folder name: $FOLDER_NAME"

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Copy new reports to timestamped folder with playwright/ and allure/ subdirs
echo "Creating timestamped report: $FOLDER_NAME"
mkdir -p "${REPORTS_DIR}/${FOLDER_NAME}/playwright"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/${FOLDER_NAME}/playwright/"
mkdir -p "${REPORTS_DIR}/${FOLDER_NAME}/allure"
cp -r "${ALLURE_SOURCE}"/* "${REPORTS_DIR}/${FOLDER_NAME}/allure/"

# Copy to latest_{env} (overwrite)
echo "Updating ${LATEST_FOLDER}..."
rm -rf "${REPORTS_DIR:?}/${LATEST_FOLDER:?}"
mkdir -p "${REPORTS_DIR}/${LATEST_FOLDER}/playwright"
cp -r "${PLAYWRIGHT_SOURCE}"/* "${REPORTS_DIR}/${LATEST_FOLDER}/playwright/"
mkdir -p "${REPORTS_DIR}/${LATEST_FOLDER}/allure"
cp -r "${ALLURE_SOURCE}"/* "${REPORTS_DIR}/${LATEST_FOLDER}/allure/"

# Generate reports index
find "$REPORTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort -r > "${REPORTS_DIR}/reports-index.json.tmp"
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
