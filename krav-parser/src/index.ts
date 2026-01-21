import { glob } from 'glob';
import { resolve } from 'path';
import { KravDatabase } from './database.js';
import { parseFeatureFile } from './parser.js';

const KRAV_ROOT = resolve(import.meta.dirname, '../../krav');

// Build database URL from separate components or use DATABASE_URL directly
function getDatabaseUrl(): string {
  // If DATABASE_URL is provided, use it directly (backwards compatible)
  if (process.env.DATABASE_URL) {
    return process.env.DATABASE_URL;
  }

  // Otherwise, build from separate components
  const { DB_HOST, DB_PORT, DB_NAME, DB_USR, DB_PW } = process.env;

  if (!DB_HOST || !DB_NAME || !DB_USR || !DB_PW) {
    console.error('ERROR: Database configuration required');
    console.error('Either set DATABASE_URL or all of: DB_HOST, DB_PORT, DB_NAME, DB_USR, DB_PW');
    process.exit(1);
  }

  const port = DB_PORT || '5432';
  return `postgresql://${DB_USR}:${DB_PW}@${DB_HOST}:${port}/${DB_NAME}`;
}

const dbUrl = getDatabaseUrl();

// Format steps as comma-separated text: "Gitt step1, Når step2, Så step3"
function formatSteps(steps: { keyword: string; text: string }[]): string {
  return steps.map(s => `${s.keyword} ${s.text}`).join(', ');
}

async function main() {
  console.log('Starting krav-parser...');
  console.log(`Scanning: ${KRAV_ROOT}`);

  // Find all feature files in all domain folders
  const featureFiles = await glob('**/*.feature', {
    cwd: KRAV_ROOT,
    absolute: true,
  });

  console.log(`Found ${featureFiles.length} feature files`);

  // Initialize database
  const db = new KravDatabase(dbUrl);
  await db.init();
  await db.truncateAll();

  // Track domains, subdomains, and capabilities to avoid duplicates
  const domainCache = new Map<string, number>();
  const subdomainCache = new Map<string, number>();
  const capabilityCache = new Map<string, number>();

  let successCount = 0;
  let errorCount = 0;
  let skippedCount = 0;

  for (const filePath of featureFiles) {
    const parsed = parseFeatureFile(filePath, KRAV_ROOT);

    if (!parsed) {
      errorCount++;
      continue;
    }

    // Skip files without Feature-ID (required as primary key)
    if (!parsed.feature.feature_id) {
      console.warn(`SKIPPED: ${parsed.filePath} - Missing Feature-ID`);
      skippedCount++;
      continue;
    }

    try {
      // Get or create domain
      let domainId = domainCache.get(parsed.domain.folder_name);
      if (!domainId) {
        domainId = await db.insertDomain(parsed.domain);
        domainCache.set(parsed.domain.folder_name, domainId);
      }

      // Get or create subdomain
      let subdomainId: number | null = null;
      if (parsed.subdomain) {
        const subdomainKey = `${domainId}:${parsed.subdomain.folder_name}`;
        subdomainId = subdomainCache.get(subdomainKey) ?? null;
        if (!subdomainId) {
          subdomainId = await db.insertSubdomain({
            domain_id: domainId,
            ...parsed.subdomain,
          });
          subdomainCache.set(subdomainKey, subdomainId);
        }
      }

      // Get or create capability
      let capabilityId: number | null = null;
      if (parsed.capability && subdomainId) {
        const capabilityKey = `${subdomainId}:${parsed.capability.folder_name}`;
        capabilityId = capabilityCache.get(capabilityKey) ?? null;
        if (!capabilityId) {
          capabilityId = await db.insertCapability({
            subdomain_id: subdomainId,
            ...parsed.capability,
          });
          capabilityCache.set(capabilityKey, capabilityId);
        }
      }

      // Insert feature
      const featureId = await db.insertFeature({
        feature_id: parsed.feature.feature_id,
        domain_id: domainId,
        subdomain_id: subdomainId,
        capability_id: capabilityId,
        file_path: parsed.filePath,
        file_name: parsed.filePath.split('/').pop()!,
        name: parsed.feature.name,
        description: parsed.feature.description,
        status: parsed.feature.status,
        priority: parsed.feature.priority,
        tags: parsed.feature.tags,
      });

      // Insert rules and their scenarios
      for (let ruleIdx = 0; ruleIdx < parsed.rules.length; ruleIdx++) {
        const rule = parsed.rules[ruleIdx];
        const ruleId = await db.insertRule({
          feature_id: featureId,
          name: rule.name,
          status: rule.status,
          priority: rule.priority,
          sort_order: ruleIdx,
        });

        for (let scenarioIdx = 0; scenarioIdx < rule.scenarios.length; scenarioIdx++) {
          const scenario = rule.scenarios[scenarioIdx];
          await db.insertScenario({
            feature_id: featureId,
            rule_id: ruleId,
            name: scenario.name,
            steps: formatSteps(scenario.steps),
            status: scenario.status,
            priority: scenario.priority,
            tags: scenario.tags,
            sort_order: scenarioIdx,
          });
        }
      }

      // Insert scenarios not under any rule
      for (let scenarioIdx = 0; scenarioIdx < parsed.scenarios.length; scenarioIdx++) {
        const scenario = parsed.scenarios[scenarioIdx];
        await db.insertScenario({
          feature_id: featureId,
          rule_id: null,
          name: scenario.name,
          steps: formatSteps(scenario.steps),
          status: scenario.status,
          priority: scenario.priority,
          tags: scenario.tags,
          sort_order: scenarioIdx,
        });
      }

      // Insert open questions
      for (const question of parsed.openQuestions) {
        await db.insertOpenQuestion({
          feature_id: featureId,
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
  console.log(`Skipped (no Feature-ID): ${skippedCount} files`);
  console.log(`Errors: ${errorCount} files`);
  console.log('\n--- Database Stats ---');
  const stats = await db.getStats();
  for (const [table, count] of Object.entries(stats)) {
    console.log(`${table}: ${count}`);
  }

  await db.close();
  console.log('\nDone!');
}

main().catch(console.error);
