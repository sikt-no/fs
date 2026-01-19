# PostgreSQL Migration Plan for krav-parser

## Overview

Migrate krav-parser from SQLite (sql.js) to PostgreSQL on AWS RDS, with credentials from Vault and execution via GitLab CI/CD.

## Configuration Summary

| Setting | Value |
|---------|-------|
| Database | Existing AWS RDS PostgreSQL instance |
| Credentials | Vault (`productareas/studieadm/fs/krav-parser/`) |
| Library | pg (node-postgres) |
| Execution | GitLab CI/CD scheduled/manual job |

## Files to Modify

### 1. `krav-parser/package.json`

Add PostgreSQL dependencies, remove sql.js:

```json
{
  "dependencies": {
    "@cucumber/gherkin": "^29.0.0",
    "@cucumber/messages": "^26.0.0",
    "pg": "^8.11.0",
    "glob": "^11.0.0"
  },
  "devDependencies": {
    "@types/pg": "^8.10.0"
  }
}
```

### 2. `krav-parser/sql/schema.sql`

Convert to PostgreSQL syntax:

```sql
-- PostgreSQL schema for krav-parser

CREATE TABLE IF NOT EXISTS domains (
    id SERIAL PRIMARY KEY,
    folder_name TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subdomains (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
    folder_name TEXT NOT NULL,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(domain_id, folder_name)
);

CREATE TABLE IF NOT EXISTS requirements (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
    subdomain_id INTEGER REFERENCES subdomains(id) ON DELETE CASCADE,
    file_path TEXT NOT NULL UNIQUE,
    file_name TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT,
    priority TEXT,
    tags JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rules (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status TEXT,
    priority TEXT,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS examples (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    rule_id INTEGER REFERENCES rules(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    steps TEXT,
    status TEXT,
    priority TEXT,
    tags JSONB,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS open_questions (
    id SERIAL PRIMARY KEY,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_requirements_domain ON requirements(domain_id);
CREATE INDEX IF NOT EXISTS idx_requirements_subdomain ON requirements(subdomain_id);
CREATE INDEX IF NOT EXISTS idx_requirements_status ON requirements(status);
CREATE INDEX IF NOT EXISTS idx_requirements_priority ON requirements(priority);
CREATE INDEX IF NOT EXISTS idx_examples_requirement ON examples(requirement_id);
CREATE INDEX IF NOT EXISTS idx_examples_rule ON examples(rule_id);
CREATE INDEX IF NOT EXISTS idx_rules_requirement ON rules(requirement_id);
```

**Key changes from SQLite:**
- `INTEGER PRIMARY KEY AUTOINCREMENT` → `SERIAL PRIMARY KEY`
- `TEXT DEFAULT CURRENT_TIMESTAMP` → `TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP`
- `TEXT` for JSON → `JSONB` for native JSON support

### 3. `krav-parser/src/database.ts`

Replace sql.js with pg:

```typescript
import { Pool } from 'pg';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import type { Domain, Subdomain, Requirement, Rule, Example, OpenQuestion } from './types.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export class KravDatabase {
  private pool: Pool;

  constructor(connectionString: string) {
    this.pool = new Pool({ connectionString });
  }

  async init(): Promise<void> {
    const schemaPath = join(__dirname, '..', 'sql', 'schema.sql');
    const schema = readFileSync(schemaPath, 'utf-8');
    await this.pool.query(schema);
    console.log('Database initialized');
  }

  async truncateAll(): Promise<void> {
    await this.pool.query(`
      TRUNCATE open_questions, examples, rules, requirements, subdomains, domains CASCADE
    `);
    console.log('All tables truncated');
  }

  async insertDomain(domain: Omit<Domain, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO domains (folder_name, name, sort_order) VALUES ($1, $2, $3) RETURNING id',
      [domain.folder_name, domain.name, domain.sort_order]
    );
    return result.rows[0].id;
  }

  async insertSubdomain(subdomain: Omit<Subdomain, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO subdomains (domain_id, folder_name, name, sort_order) VALUES ($1, $2, $3, $4) RETURNING id',
      [subdomain.domain_id, subdomain.folder_name, subdomain.name, subdomain.sort_order]
    );
    return result.rows[0].id;
  }

  async insertRequirement(requirement: Omit<Requirement, 'id'>): Promise<number> {
    const result = await this.pool.query(
      `INSERT INTO requirements (domain_id, subdomain_id, file_path, file_name, name, description, status, priority, tags)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id`,
      [
        requirement.domain_id,
        requirement.subdomain_id,
        requirement.file_path,
        requirement.file_name,
        requirement.name,
        requirement.description,
        requirement.status,
        requirement.priority,
        JSON.stringify(requirement.tags),
      ]
    );
    return result.rows[0].id;
  }

  async insertRule(rule: Omit<Rule, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO rules (requirement_id, name, status, priority, sort_order) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [rule.requirement_id, rule.name, rule.status, rule.priority, rule.sort_order]
    );
    return result.rows[0].id;
  }

  async insertExample(example: Omit<Example, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO examples (requirement_id, rule_id, name, steps, status, priority, tags, sort_order) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id',
      [
        example.requirement_id,
        example.rule_id,
        example.name,
        example.steps,
        example.status,
        example.priority,
        JSON.stringify(example.tags),
        example.sort_order,
      ]
    );
    return result.rows[0].id;
  }

  async insertOpenQuestion(question: Omit<OpenQuestion, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO open_questions (requirement_id, question) VALUES ($1, $2) RETURNING id',
      [question.requirement_id, question.question]
    );
    return result.rows[0].id;
  }

  async getStats(): Promise<Record<string, number>> {
    const tables = ['domains', 'subdomains', 'requirements', 'rules', 'examples', 'open_questions'];
    const stats: Record<string, number> = {};

    for (const table of tables) {
      const result = await this.pool.query(`SELECT COUNT(*) as count FROM ${table}`);
      stats[table] = parseInt(result.rows[0].count, 10);
    }

    return stats;
  }

  async close(): Promise<void> {
    await this.pool.end();
    console.log('Database connection closed');
  }
}
```

**Key changes:**
- `Pool` for connection management
- All methods now `async`
- Parameterized queries with `$1, $2, ...` instead of `?`
- `RETURNING id` instead of `last_insert_rowid()`
- Results accessed via `result.rows[0]`

### 4. `krav-parser/src/index.ts`

Update to use async database and read connection string from environment:

```typescript
// Add at top
const DATABASE_URL = process.env.DATABASE_URL;
if (!DATABASE_URL) {
  throw new Error('DATABASE_URL environment variable is required');
}

// Change database initialization
const db = new KravDatabase(DATABASE_URL);
await db.init();
await db.truncateAll();

// All db.insert* calls need await
domainId = await db.insertDomain(parsed.domain);
// ... etc
```

### 5. Update `.gitlab-ci.yml` (in repo root)

Add krav-parser job with Vault integration:

```yaml
krav_parser:
  stage: test
  image: node:20
  id_tokens:
    VAULT_ID_TOKEN:
      aud: "https://vault.sikt.no:8200"
  secrets:
    DATABASE_URL:
      vault: "gitlab/studieadm/sikt-no-fs/krav-parser/db/url@secret"
      file: false
  before_script:
    - cd krav-parser
    - npm ci
  script:
    - npm run parse
  rules:
    - if: $CI_PIPELINE_SOURCE == "schedule"
    - if: $CI_PIPELINE_SOURCE == "web"
    - if: $CI_PIPELINE_SOURCE == "trigger"
```

## Vault Setup Required

Before the pipeline can run, create the secret in Vault:

```bash
# Login to Vault
export VAULT_ADDR=https://vault.sikt.no:8200
vault login -method=ldap username=<your-username>

# Create the database URL secret (includes password in connection string)
vault kv put -mount=secret gitlab/studieadm/sikt-no-fs/krav-parser/db \
  url="postgresql://user:password@rds-endpoint.amazonaws.com:5432/fs-akseptansekrav?sslmode=require"
```

The connection string format: `postgresql://user:password@host:port/database?sslmode=require`

## Implementation Order

1. **Set up Vault secret** - Create the DATABASE_URL secret
2. **Update package.json** - Add pg, remove sql.js
3. **Update schema.sql** - Convert to PostgreSQL syntax
4. **Update database.ts** - Replace sql.js with pg (async)
5. **Update index.ts** - Make async, read DATABASE_URL from env
6. **Update .gitlab-ci.yml** - Add krav_parser job
7. **Test locally** - Run against RDS with local DATABASE_URL
8. **Commit and push** - Merge to main, run pipeline

## Verification

1. **Local test**: Set `DATABASE_URL` environment variable and run `npm run parse`
2. **Check database**: Connect to RDS and verify tables are created and populated
3. **Pipeline test**: Trigger manual pipeline and check job logs
4. **Query data**: Verify requirements, rules, examples are in PostgreSQL

```sql
-- Verify data in PostgreSQL
SELECT COUNT(*) FROM requirements;
SELECT name, status, priority FROM requirements;
SELECT r.name, e.name, e.status FROM requirements r JOIN examples e ON r.id = e.requirement_id;
```
