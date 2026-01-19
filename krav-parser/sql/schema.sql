-- SQLite schema for krav-parser

-- Domains (from top-level folders like "02 Opptak")
CREATE TABLE IF NOT EXISTS domains (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    folder_name TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Sub-domains (from nested folders like "03 Søknadsbehandling")
CREATE TABLE IF NOT EXISTS subdomains (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    domain_id INTEGER NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
    folder_name TEXT NOT NULL,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(domain_id, folder_name)
);

-- Requirements (from Feature/Egenskap in .feature files)
CREATE TABLE IF NOT EXISTS requirements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    domain_id INTEGER NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
    subdomain_id INTEGER REFERENCES subdomains(id) ON DELETE CASCADE,
    file_path TEXT NOT NULL UNIQUE,
    file_name TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT,
    priority TEXT,
    tags TEXT,  -- JSON array stored as text
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Rules (from Regel: in .feature files)
CREATE TABLE IF NOT EXISTS rules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status TEXT,
    priority TEXT,
    sort_order INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Examples (from Scenario: in .feature files)
CREATE TABLE IF NOT EXISTS examples (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    rule_id INTEGER REFERENCES rules(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    steps TEXT,  -- All steps as text (comma-separated)
    status TEXT,
    priority TEXT,
    tags TEXT,  -- JSON array stored as text
    sort_order INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Open Questions (from # OPEN QUESTIONS: sections)
CREATE TABLE IF NOT EXISTS open_questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    requirement_id INTEGER NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_requirements_domain ON requirements(domain_id);
CREATE INDEX IF NOT EXISTS idx_requirements_subdomain ON requirements(subdomain_id);
CREATE INDEX IF NOT EXISTS idx_requirements_status ON requirements(status);
CREATE INDEX IF NOT EXISTS idx_requirements_priority ON requirements(priority);
CREATE INDEX IF NOT EXISTS idx_examples_requirement ON examples(requirement_id);
CREATE INDEX IF NOT EXISTS idx_examples_rule ON examples(rule_id);
CREATE INDEX IF NOT EXISTS idx_rules_requirement ON rules(requirement_id);
