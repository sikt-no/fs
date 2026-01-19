import initSqlJs from 'sql.js';
import { readFileSync } from 'fs';

async function main() {
  const SQL = await initSqlJs();
  const db = new SQL.Database(readFileSync('krav.db'));

  console.log('=== DOMAINS ===');
  const domains = db.exec('SELECT * FROM domains');
  console.log('id | folder_name | name | sort_order');
  domains[0]?.values.forEach(row => console.log(row.join(' | ')));

  console.log('\n=== REQUIREMENTS ===');
  const requirements = db.exec('SELECT id, name, status, priority FROM requirements');
  console.log('id | name | status | priority');
  requirements[0]?.values.forEach(row => console.log(row.join(' | ')));

  console.log('\n=== RULES ===');
  const rules = db.exec('SELECT * FROM rules');
  console.log('id | requirement_id | name | sort_order');
  rules[0]?.values.forEach(row => console.log(row.join(' | ')));

  console.log('\n=== EXAMPLES ===');
  const examples = db.exec('SELECT id, requirement_id, rule_id, name FROM examples');
  console.log('id | requirement_id | rule_id | name');
  examples[0]?.values.forEach(row => console.log(row.join(' | ')));

  console.log('\n=== EXAMPLE STEPS ===');
  const exampleSteps = db.exec('SELECT name, steps FROM examples LIMIT 3');
  exampleSteps[0]?.values.forEach(row => {
    console.log(`\n${row[0]}:`);
    console.log(`  ${row[1]}`);
  });

  db.close();
}

main();
