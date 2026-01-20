-- PostgreSQL schema for krav-parser (Gherkin terminology)

-- Domains (from top-level folders like "02 Opptak")
CREATE TABLE IF NOT EXISTS domains (
    id SERIAL PRIMARY KEY,
    folder_name TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Sub-domains (from nested folders like "03 Søknadsbehandling")
CREATE TABLE IF NOT EXISTS subdomains (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
    folder_name TEXT NOT NULL,
    name TEXT NOT NULL,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(domain_id, folder_name)
);

-- Features (from Feature/Egenskap in .feature files)
CREATE TABLE IF NOT EXISTS features (
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

-- Rules (from Regel: in .feature files)
CREATE TABLE IF NOT EXISTS rules (
    id SERIAL PRIMARY KEY,
    feature_id INTEGER NOT NULL REFERENCES features(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status TEXT,
    priority TEXT,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Scenarios (from Scenario: in .feature files)
CREATE TABLE IF NOT EXISTS scenarios (
    id SERIAL PRIMARY KEY,
    feature_id INTEGER NOT NULL REFERENCES features(id) ON DELETE CASCADE,
    rule_id INTEGER REFERENCES rules(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    steps TEXT,
    status TEXT,
    priority TEXT,
    tags JSONB,
    sort_order INTEGER,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Open Questions (from # OPEN QUESTIONS: sections)
CREATE TABLE IF NOT EXISTS open_questions (
    id SERIAL PRIMARY KEY,
    feature_id INTEGER NOT NULL REFERENCES features(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_features_domain ON features(domain_id);
CREATE INDEX IF NOT EXISTS idx_features_subdomain ON features(subdomain_id);
CREATE INDEX IF NOT EXISTS idx_features_status ON features(status);
CREATE INDEX IF NOT EXISTS idx_features_priority ON features(priority);
CREATE INDEX IF NOT EXISTS idx_scenarios_feature ON scenarios(feature_id);
CREATE INDEX IF NOT EXISTS idx_scenarios_rule ON scenarios(rule_id);
CREATE INDEX IF NOT EXISTS idx_rules_feature ON rules(feature_id);
