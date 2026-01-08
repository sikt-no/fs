FROM mcr.microsoft.com/playwright:v1.57.0-noble

LABEL com.jfrog.artifactory.retention.maxDays="180"

WORKDIR /app

# Copy package files first for better layer caching
COPY tester/package.json tester/package-lock.json ./tester/

# Install dependencies
WORKDIR /app/tester
RUN npm ci

# Copy test configuration and source files
COPY tester/playwright.config.ts tester/tsconfig.json ./
COPY tester/steps/ ./steps/
COPY tester/fixtures/ ./fixtures/
COPY tester/queries/ ./queries/

# Copy feature files (at ../krav relative to tester)
WORKDIR /app
COPY krav/ ./krav/

# Run tests from tester directory
WORKDIR /app/tester
CMD ["npm", "test"]
