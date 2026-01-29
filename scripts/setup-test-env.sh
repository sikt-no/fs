#!/bin/bash
# Setup test environment based on TEST_ENV variable
# Creates /tmp/test-env.sh with environment-specific URLs and REPORT_TIMESTAMP
# Usage: Called from e2e_tests before_script, script, and after_script

set -e

# TEST_ENV must be set (from GitLab CI variables)
if [ -z "$TEST_ENV" ]; then
  echo "ERROR: TEST_ENV is not set"
  exit 1
fi

# REPORT_TIMESTAMP must be set (from before_script)
if [ -z "$REPORT_TIMESTAMP" ]; then
  echo "ERROR: REPORT_TIMESTAMP is not set"
  exit 1
fi

# Set URLs based on TEST_ENV and write to env file for persistence
if [ "$TEST_ENV" = "test" ]; then
  cat > /tmp/test-env.sh << 'ENVEOF'
export FS_ADMIN_URL="https://test-fsadmin.sikt.no"
export FS_ADMIN_GRAPHQL="https://test-fsadmin.sikt.no/api/graphql"
export MIN_KOMPETANSE_URL="https://test.minkompetanse.no/nb"
export GRAPHQL_ENDPOINT="https://supergraf-gateway-apollo-test.sokrates.edupaas.no/graphql"
ENVEOF
else
  cat > /tmp/test-env.sh << 'ENVEOF'
export FS_ADMIN_URL="https://studieadm-fs-admin-functionaltest.sokrates.edupaas.no"
export FS_ADMIN_GRAPHQL="https://studieadm-fs-admin-functionaltest.sokrates.edupaas.no/api/graphql"
export MIN_KOMPETANSE_URL="https://minkompetanse-functionaltest.sokrates.edupaas.no/nb"
export GRAPHQL_ENDPOINT="https://supergraf-gateway-apollo-functionaltest.sokrates.edupaas.no/graphql"
ENVEOF
fi

# Add REPORT_TIMESTAMP to env file
echo "export REPORT_TIMESTAMP=\"$REPORT_TIMESTAMP\"" >> /tmp/test-env.sh

# Source the env file to make variables available in current shell
# shellcheck disable=SC1091  # File is generated dynamically by this script
source /tmp/test-env.sh

# Print configuration for debugging
echo "Using TEST_ENV=$TEST_ENV"
echo "FS_ADMIN_URL=$FS_ADMIN_URL"
echo "REPORT_TIMESTAMP=$REPORT_TIMESTAMP"
