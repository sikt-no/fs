# CI/CD Scripts

Bash scripts used in GitLab CI pipeline for test execution, reporting, and deployment.

## Scripts Overview

### setup-test-env.sh
**Purpose**: Configure environment-specific URLs based on TEST_ENV variable

**Usage**: Called from `e2e_tests` before_script
```yaml
before_script:
  - export REPORT_TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
  - ../scripts/setup-test-env.sh
```

**What it does**:
- Creates `/tmp/test-env.sh` with environment-specific URLs
- Supports two environments: `test` and `functionaltest`
- Exports: FS_ADMIN_URL, FS_ADMIN_GRAPHQL, MIN_KOMPETANSE_URL, GRAPHQL_ENDPOINT, REPORT_TIMESTAMP
- Must be sourced by other scripts to access variables

**Required environment variables**:
- `TEST_ENV` - Set to "test" or "functionaltest"
- `REPORT_TIMESTAMP` - Generated timestamp for reports

### fetch-allure-history.sh
**Purpose**: Download Allure history from previous successful pipeline run

**Usage**: Called from `e2e_tests` before_script (after npm ci)
```yaml
before_script:
  - ../scripts/fetch-allure-history.sh
```

**What it does**:
- Downloads `history.zip` artifact from last successful e2e_tests job on main
- Extracts and copies history to `allure-results/history`
- Fails gracefully if no history exists

**Required environment variables**:
- `CI_API_V4_URL` - GitLab API URL
- `CI_PROJECT_ID` - Project ID
- `CI_JOB_TOKEN` - Job token for API access

**Working directory**: Must be run from `tester/` directory

### generate-slack-payload.sh
**Purpose**: Extract test metrics from Playwright results and generate Slack notification payload

**Usage**: Called from `e2e_tests` after_script
```yaml
after_script:
  - cd tester
  - ../scripts/generate-slack-payload.sh
```

**What it does**:
- Sources `/tmp/test-env.sh` for environment variables
- Parses `test-results/results.json` for test metrics
- Extracts: TEST_PASSED, TEST_FAILED, TEST_SKIPPED, TEST_DURATION
- Categorizes failures by type (DNS, Timeout, Auth, Element, Backend)
- Selects appropriate Slack template (passed.json or failed.json)
- Generates `slack-payload.json` using envsubst

**Exports**: All test metrics for use by Slack templates

**Working directory**: Must be run from `tester/` directory

**Slack payload**: Saved to `tester/slack-payload.json` (sent later by production job)

### organize-reports.sh *(existing)*
**Purpose**: Organize test reports for deployment

**Usage**: Called from `prepare-reports` job

### entrypoint.sh *(existing)*
**Purpose**: Docker container entrypoint

## Development

### Local Testing

You can test scripts locally by mocking environment variables:

```bash
# Test setup-test-env.sh
export TEST_ENV="functionaltest"
export REPORT_TIMESTAMP="2026-01-29_14-30-00"
./scripts/setup-test-env.sh
source /tmp/test-env.sh
echo "FS_ADMIN_URL=$FS_ADMIN_URL"  # Verify

# Test generate-slack-payload.sh (requires test results)
cd tester
export TEST_ENV="functionaltest"
export REPORT_TIMESTAMP="2026-01-29_14-30-00"
../scripts/setup-test-env.sh
# Run tests first: npm test
../scripts/generate-slack-payload.sh
cat slack-payload.json  # Verify
```

### ShellCheck Validation

Validate all scripts before committing:

```bash
cd tester
npm run lint:scripts
```

This runs ShellCheck on all `../scripts/*.sh` files.

## Best Practices

1. ✅ Use `set -e` to exit on errors
2. ✅ Document required environment variables
3. ✅ Document expected working directory
4. ✅ Add clear comments explaining logic
5. ✅ Test scripts locally before pushing
6. ✅ Run ShellCheck before committing

## Pipeline Flow

```
e2e_tests (stage: test)
├── before_script
│   ├── Install dependencies (apt-get, npm ci)
│   ├── Generate REPORT_TIMESTAMP
│   ├── setup-test-env.sh → Creates /tmp/test-env.sh
│   └── fetch-allure-history.sh → Downloads history
├── script
│   ├── source /tmp/test-env.sh
│   ├── Run tests (npm test)
│   └── Generate Allure report
└── after_script
    └── generate-slack-payload.sh → Creates slack-payload.json

prepare-reports (stage: build)
└── organize-reports.sh → Organize reports for deployment

production (stage: production)
└── after_script → Send slack-payload.json to Slack webhook
```

## Troubleshooting

### Script fails with "TEST_ENV not set"
Ensure TEST_ENV is set in GitLab CI variables

### Script fails with "command not found"
Verify script paths are relative to working directory:
- From `tester/`: Use `../scripts/script-name.sh`
- From root: Use `./scripts/script-name.sh`

### /tmp/test-env.sh not found
Ensure `setup-test-env.sh` runs before scripts that source it

### Slack payload missing variables
Verify `generate-slack-payload.sh` sources `/tmp/test-env.sh`
