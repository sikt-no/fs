import { glob } from 'glob';
import { resolve } from 'path';
import { KravDatabase } from './database.js';
import { parseFeatureFile } from './parser.js';

const KRAV_ROOT = resolve(import.meta.dirname, '../../krav');

// Format steps as comma-separated text: "Gitt step1, Når step2, Så step3"
function formatSteps(steps: { keyword: string; text: string }[]): string {
  return steps.map(s => `${s.keyword} ${s.text}`).join(', ');
}

async function main() {
  console.log('Starting krav-parser...');
  console.log(`Scanning: ${KRAV_ROOT}`);

  // Find all feature files (focusing on demo folder for now)
  const featureFiles = await glob('99 Demo/**/*.feature', {
    cwd: KRAV_ROOT,
    absolute: true,
  });

  console.log(`Found ${featureFiles.length} feature files`);

  // Initialize database
  const db = new KravDatabase('krav.db');
  await db.init();
  db.truncateAll();

  // Track domains and subdomains to avoid duplicates
  const domainCache = new Map<string, number>();
  const subdomainCache = new Map<string, number>();

  let successCount = 0;
  let errorCount = 0;

  for (const filePath of featureFiles) {
    const parsed = parseFeatureFile(filePath, KRAV_ROOT);

    if (!parsed) {
      errorCount++;
      continue;
    }

    try {
      // Get or create domain
      let domainId = domainCache.get(parsed.domain.folder_name);
      if (!domainId) {
        domainId = db.insertDomain(parsed.domain);
        domainCache.set(parsed.domain.folder_name, domainId);
      }

      // Get or create subdomain
      let subdomainId: number | null = null;
      if (parsed.subdomain) {
        const subdomainKey = `${domainId}:${parsed.subdomain.folder_name}`;
        subdomainId = subdomainCache.get(subdomainKey) ?? null;
        if (!subdomainId) {
          subdomainId = db.insertSubdomain({
            domain_id: domainId,
            ...parsed.subdomain,
          });
          subdomainCache.set(subdomainKey, subdomainId);
        }
      }

      // Insert requirement
      const requirementId = db.insertRequirement({
        domain_id: domainId,
        subdomain_id: subdomainId,
        file_path: parsed.filePath,
        file_name: parsed.filePath.split('/').pop()!,
        name: parsed.requirement.name,
        description: parsed.requirement.description,
        status: parsed.requirement.status,
        priority: parsed.requirement.priority,
        tags: parsed.requirement.tags,
      });

      // Insert rules and their examples
      for (let ruleIdx = 0; ruleIdx < parsed.rules.length; ruleIdx++) {
        const rule = parsed.rules[ruleIdx];
        const ruleId = db.insertRule({
          requirement_id: requirementId,
          name: rule.name,
          status: rule.status,
          priority: rule.priority,
          sort_order: ruleIdx,
        });

        for (let exampleIdx = 0; exampleIdx < rule.examples.length; exampleIdx++) {
          const example = rule.examples[exampleIdx];
          db.insertExample({
            requirement_id: requirementId,
            rule_id: ruleId,
            name: example.name,
            steps: formatSteps(example.steps),
            status: example.status,
            priority: example.priority,
            tags: example.tags,
            sort_order: exampleIdx,
          });
        }
      }

      // Insert examples not under any rule
      for (let exampleIdx = 0; exampleIdx < parsed.examples.length; exampleIdx++) {
        const example = parsed.examples[exampleIdx];
        db.insertExample({
          requirement_id: requirementId,
          rule_id: null,
          name: example.name,
          steps: formatSteps(example.steps),
          status: example.status,
          priority: example.priority,
          tags: example.tags,
          sort_order: exampleIdx,
        });
      }

      // Insert open questions
      for (const question of parsed.openQuestions) {
        db.insertOpenQuestion({
          requirement_id: requirementId,
          question,
        });
      }

      successCount++;
    } catch (error) {
      console.error(`Error processing ${filePath}:`, error);
      errorCount++;
    }
  }

  // Print stats
  console.log('\n--- Results ---');
  console.log(`Processed: ${successCount} files`);
  console.log(`Errors: ${errorCount} files`);
  console.log('\n--- Database Stats ---');
  const stats = db.getStats();
  for (const [table, count] of Object.entries(stats)) {
    console.log(`${table}: ${count}`);
  }

  db.close();
  console.log('\nDone!');
}

main().catch(console.error);
