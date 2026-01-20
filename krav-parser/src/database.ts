import { Pool } from 'pg';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import type { Domain, Subdomain, Feature, Rule, Scenario, OpenQuestion } from './types.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export class KravDatabase {
  private pool: Pool;

  constructor(connectionString: string) {
    this.pool = new Pool({
      connectionString,
      ssl: { rejectUnauthorized: false }
    });
  }

  async init(): Promise<void> {
    const schemaPath = join(__dirname, '..', 'sql', 'schema.sql');
    const schema = readFileSync(schemaPath, 'utf-8');
    await this.pool.query(schema);
    console.log('Database initialized');
  }

  async truncateAll(): Promise<void> {
    await this.pool.query(`
      TRUNCATE open_questions, scenarios, rules, features, subdomains, domains CASCADE
    `);
    console.log('All tables truncated');
  }

  // Domain operations
  async insertDomain(domain: Omit<Domain, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO domains (folder_name, name, sort_order) VALUES ($1, $2, $3) RETURNING id',
      [domain.folder_name, domain.name, domain.sort_order]
    );
    return result.rows[0].id;
  }

  async getDomainByFolderName(folderName: string): Promise<Domain | undefined> {
    const result = await this.pool.query(
      'SELECT * FROM domains WHERE folder_name = $1',
      [folderName]
    );
    if (result.rows.length === 0) return undefined;
    const row = result.rows[0];
    return {
      id: row.id,
      folder_name: row.folder_name,
      name: row.name,
      sort_order: row.sort_order,
    };
  }

  // Subdomain operations
  async insertSubdomain(subdomain: Omit<Subdomain, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO subdomains (domain_id, folder_name, name, sort_order) VALUES ($1, $2, $3, $4) RETURNING id',
      [subdomain.domain_id, subdomain.folder_name, subdomain.name, subdomain.sort_order]
    );
    return result.rows[0].id;
  }

  // Feature operations
  async insertFeature(feature: Omit<Feature, 'id'>): Promise<number> {
    const result = await this.pool.query(
      `INSERT INTO features (domain_id, subdomain_id, file_path, file_name, name, description, status, priority, tags)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id`,
      [
        feature.domain_id,
        feature.subdomain_id,
        feature.file_path,
        feature.file_name,
        feature.name,
        feature.description,
        feature.status,
        feature.priority,
        JSON.stringify(feature.tags),
      ]
    );
    return result.rows[0].id;
  }

  // Rule operations
  async insertRule(rule: Omit<Rule, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO rules (feature_id, name, status, priority, sort_order) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [rule.feature_id, rule.name, rule.status, rule.priority, rule.sort_order]
    );
    return result.rows[0].id;
  }

  // Scenario operations
  async insertScenario(scenario: Omit<Scenario, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO scenarios (feature_id, rule_id, name, steps, status, priority, tags, sort_order) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id',
      [
        scenario.feature_id,
        scenario.rule_id,
        scenario.name,
        scenario.steps,
        scenario.status,
        scenario.priority,
        JSON.stringify(scenario.tags),
        scenario.sort_order,
      ]
    );
    return result.rows[0].id;
  }

  // Open question operations
  async insertOpenQuestion(question: Omit<OpenQuestion, 'id'>): Promise<number> {
    const result = await this.pool.query(
      'INSERT INTO open_questions (feature_id, question) VALUES ($1, $2) RETURNING id',
      [question.feature_id, question.question]
    );
    return result.rows[0].id;
  }

  // Stats
  async getStats(): Promise<Record<string, number>> {
    const tables = ['domains', 'subdomains', 'features', 'rules', 'scenarios', 'open_questions'];
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
