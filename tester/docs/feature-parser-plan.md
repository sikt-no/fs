# Feature File Parser - Plan

## Overview

Create a parser that reads `.feature` files, extracts structured data, and stores it in PostgreSQL for requirements traceability.

## Goals

1. Track which requirements (features) are implemented vs planned
2. Categorize requirements by domain, sub-domain
3. Track MoSCoW priority
4. Capture open questions

## Data Model

### Hierarchy (Example Mapping terminology)

```
Domain (from folder)
  └── Sub-domain (from folder)
       └── Requirement (from Egenskap:)
            └── Rule (from Regel:)
                 └── Example (from Scenario:)
                      └── Step (Given/When/Then)
```

### Database Schema

```sql
-- Domains (from top-level folders like "02 Opptak")
CREATE TABLE domains (
    id SERIAL PRIMARY KEY,
    folder_name VARCHAR(255) NOT NULL,  -- "02 Opptak"
    name VARCHAR(255) NOT NULL,         -- "Opptak" (without number prefix)
    sort_order INTEGER,                 -- 2 (extracted from folder name)
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Sub-domains (from nested folders like "03 Søknadsbehandling")
CREATE TABLE subdomains (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id),
    folder_name VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Requirements (from Feature/Egenskap in .feature files)
CREATE TABLE requirements (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id),
    subdomain_id INTEGER REFERENCES subdomains(id),  -- nullable if directly under domain
    file_path VARCHAR(500) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    name VARCHAR(500) NOT NULL,           -- Feature name from "Egenskap:" line
    description TEXT,                      -- Feature description (lines after Egenskap:)
    status VARCHAR(50),                    -- @implemented, @in-progress, @planned
    priority VARCHAR(50),                  -- @must, @should, @could, @wont
    tags TEXT[],                           -- All other tags as array
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Rules (from Regel: in .feature files)
CREATE TABLE rules (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER REFERENCES requirements(id) ON DELETE CASCADE,
    name VARCHAR(500) NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Examples (from Scenario: in .feature files) - "Example Mapping" terminology
CREATE TABLE examples (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER REFERENCES requirements(id) ON DELETE CASCADE,
    rule_id INTEGER REFERENCES rules(id) ON DELETE CASCADE,  -- nullable if not under a rule
    name VARCHAR(500) NOT NULL,
    tags TEXT[],
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Steps (Given/When/Then from each example)
CREATE TABLE steps (
    id SERIAL PRIMARY KEY,
    example_id INTEGER REFERENCES examples(id) ON DELETE CASCADE,
    keyword VARCHAR(50) NOT NULL,         -- "Given", "When", "Then", "And", "But"
    text TEXT NOT NULL,                   -- The step text
    sort_order INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Open Questions (from # OPEN QUESTIONS: sections)
CREATE TABLE open_questions (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER REFERENCES requirements(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_requirements_domain ON requirements(domain_id);
CREATE INDEX idx_requirements_subdomain ON requirements(subdomain_id);
CREATE INDEX idx_requirements_status ON requirements(status);
CREATE INDEX idx_requirements_priority ON requirements(priority);
CREATE INDEX idx_examples_requirement ON examples(requirement_id);
CREATE INDEX idx_examples_rule ON examples(rule_id);
CREATE INDEX idx_steps_example ON steps(example_id);
CREATE INDEX idx_rules_requirement ON rules(requirement_id);
```

## Parser Implementation

### Technology

- **Language:** Node.js/TypeScript (consistent with tester/ project)
- **Gherkin Parser:** `@cucumber/gherkin` (official, supports Norwegian)
- **Database:** `pg` (PostgreSQL client for Node.js)

### Key Dependencies

```json
{
  "@cucumber/gherkin": "^29.0.0",
  "@cucumber/messages": "^25.0.0",
  "pg": "^8.11.0",
  "glob": "^10.0.0"
}
```

### Parser Logic

```
1. Scan krav/ folder for .feature files
2. For each file:
   a. Extract domain from folder path (e.g., "02 Opptak")
   b. Extract sub-domain from folder path (e.g., "03 Søknadsbehandling")
   c. Parse file with @cucumber/gherkin
   d. Extract:
      - Feature name and description
      - Tags (status, priority, other)
      - Rules and their names
      - Examples (scenarios) and their tags
      - Steps (Given/When/Then) for each example
        - Background steps prepended to ALL examples
      - Open questions from comments
3. TRUNCATE all tables (full reset)
4. Insert all data fresh to PostgreSQL
```

### Tag Parsing

**Status tags (mutually exclusive):**
- `@implemented` → status = 'implemented'
- `@in-progress` → status = 'in-progress'
- `@planned` → status = 'planned'
- No status tag → status = NULL

**Priority tags (mutually exclusive):**
- `@must` → priority = 'must'
- `@should` → priority = 'should'
- `@could` → priority = 'could'
- `@wont` → priority = 'wont'

**Other tags:** Stored in `tags` array

### Open Questions Parsing

Look for comment blocks starting with `# OPEN QUESTIONS:` or `# ÅPNE SPØRSMÅL:`

```gherkin
# OPEN QUESTIONS:
# - What happens if the user is already registered?
# - Should we send a confirmation email?
```

Each line starting with `# -` becomes a separate open question.

## Project Structure

```
krav-parser/
├── src/
│   ├── index.ts           # Main entry point
│   ├── parser.ts          # Gherkin parsing logic
│   ├── database.ts        # PostgreSQL operations
│   ├── folder-scanner.ts  # Folder structure parsing
│   └── types.ts           # TypeScript types
├── sql/
│   └── schema.sql         # Database schema
├── package.json
├── tsconfig.json
└── .env.example
```

## GitLab CI Pipeline

```yaml
parse-requirements:
  stage: parse
  image: node:20
  script:
    - cd krav-parser
    - npm ci
    - npm run parse
  rules:
    - if: $CI_PIPELINE_SOURCE == "schedule"
    - if: $CI_PIPELINE_SOURCE == "web"
    - changes:
        - krav/**/*.feature
```

## Database Connection

```
Host: uninett-postgres-11.cifui4jyekmu.eu-north-1.rds.amazonaws.com
User: studieadmnocodb_rw
Database: studieadmnocodb
```

## Decisions Made

- **No versioning** - Current state only, Git provides history if needed
- **Full reset each run** - TRUNCATE all tables and re-insert (repo is master)
- **Store steps** - Examples include full Given/When/Then steps
- **Background steps** - Prepended to ALL examples (not stored separately)
- **No table prefix** - Tables named `domains`, `subdomains`, etc.
- **Trigger on changes** - Parser runs on schedule, manual, or when .feature files change
- **React app** - Custom React dashboard will query the data

## Open Questions

None - all decisions made!

## Sources

- [Cucumber Gherkin Parser](https://github.com/cucumber/gherkin) - Official parser library
- [gherkin-parse npm](https://www.npmjs.com/package/gherkin-parse) - Alternative parser
- [Gherkin for Requirements](https://jiby.tech/post/gherkin-features-user-requirements/) - Using Gherkin for requirements traceability
