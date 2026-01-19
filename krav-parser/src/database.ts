import initSqlJs, { Database as SqlJsDatabase } from 'sql.js';
import { readFileSync, writeFileSync, existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import type { Domain, Subdomain, Requirement, Rule, Example, OpenQuestion } from './types.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export class KravDatabase {
  private db: SqlJsDatabase | null = null;
  private dbPath: string;

  constructor(dbPath: string = 'krav.db') {
    this.dbPath = dbPath;
  }

  async init(): Promise<void> {
    const SQL = await initSqlJs();

    // Load existing database or create new
    if (existsSync(this.dbPath)) {
      const buffer = readFileSync(this.dbPath);
      this.db = new SQL.Database(buffer);
    } else {
      this.db = new SQL.Database();
    }

    // Initialize schema
    const schemaPath = join(__dirname, '..', 'sql', 'schema.sql');
    const schema = readFileSync(schemaPath, 'utf-8');
    this.db.run(schema);
    console.log('Database initialized');
  }

  private ensureDb(): SqlJsDatabase {
    if (!this.db) throw new Error('Database not initialized. Call init() first.');
    return this.db;
  }

  truncateAll(): void {
    const db = this.ensureDb();
    // Order matters due to foreign keys
    db.run('DELETE FROM open_questions');
    db.run('DELETE FROM examples');
    db.run('DELETE FROM rules');
    db.run('DELETE FROM requirements');
    db.run('DELETE FROM subdomains');
    db.run('DELETE FROM domains');
    console.log('All tables truncated');
  }

  // Domain operations
  insertDomain(domain: Omit<Domain, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      'INSERT INTO domains (folder_name, name, sort_order) VALUES (?, ?, ?)',
      [domain.folder_name, domain.name, domain.sort_order]
    );
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  getDomainByFolderName(folderName: string): Domain | undefined {
    const db = this.ensureDb();
    const result = db.exec('SELECT * FROM domains WHERE folder_name = ?', [folderName]);
    if (result.length === 0 || result[0].values.length === 0) return undefined;
    const row = result[0].values[0];
    return {
      id: row[0] as number,
      folder_name: row[1] as string,
      name: row[2] as string,
      sort_order: row[3] as number,
    };
  }

  // Subdomain operations
  insertSubdomain(subdomain: Omit<Subdomain, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      'INSERT INTO subdomains (domain_id, folder_name, name, sort_order) VALUES (?, ?, ?, ?)',
      [subdomain.domain_id, subdomain.folder_name, subdomain.name, subdomain.sort_order]
    );
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  // Requirement operations
  insertRequirement(requirement: Omit<Requirement, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      `INSERT INTO requirements (domain_id, subdomain_id, file_path, file_name, name, description, status, priority, tags)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
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
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  // Rule operations
  insertRule(rule: Omit<Rule, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      'INSERT INTO rules (requirement_id, name, status, priority, sort_order) VALUES (?, ?, ?, ?, ?)',
      [rule.requirement_id, rule.name, rule.status, rule.priority, rule.sort_order]
    );
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  // Example operations
  insertExample(example: Omit<Example, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      'INSERT INTO examples (requirement_id, rule_id, name, steps, status, priority, tags, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
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
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  // Open question operations
  insertOpenQuestion(question: Omit<OpenQuestion, 'id'>): number {
    const db = this.ensureDb();
    db.run(
      'INSERT INTO open_questions (requirement_id, question) VALUES (?, ?)',
      [question.requirement_id, question.question]
    );
    const result = db.exec('SELECT last_insert_rowid() as id');
    return result[0].values[0][0] as number;
  }

  // Stats
  getStats(): Record<string, number> {
    const db = this.ensureDb();
    const tables = ['domains', 'subdomains', 'requirements', 'rules', 'examples', 'open_questions'];
    const stats: Record<string, number> = {};

    for (const table of tables) {
      const result = db.exec(`SELECT COUNT(*) as count FROM ${table}`);
      stats[table] = result[0].values[0][0] as number;
    }

    return stats;
  }

  save(): void {
    const db = this.ensureDb();
    const data = db.export();
    const buffer = Buffer.from(data);
    writeFileSync(this.dbPath, buffer);
    console.log(`Database saved to ${this.dbPath}`);
  }

  close(): void {
    if (this.db) {
      this.save();
      this.db.close();
      this.db = null;
    }
  }
}
