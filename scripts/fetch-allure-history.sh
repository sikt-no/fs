#!/bin/bash
# Fetch Allure history from previous successful pipeline
# Downloads and extracts history.zip artifact from last successful e2e_tests job on main branch
# Usage: Called from e2e_tests before_script (after npm ci, before tests run)

set -e

# Working directory should be tester/ (set by before_script: cd tester)
# Create allure-results directory if it doesn't exist
mkdir -p allure-results

# Fetch history from previous successful pipeline
curl --location --output history.zip \
  "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/jobs/artifacts/main/download?job=e2e_tests&job_token=${CI_JOB_TOKEN}" \
  && unzip -o history.zip -d previous \
  && cp -r previous/tester/allure-report/history allure-results/history \
  || echo "No previous history found, starting fresh"
