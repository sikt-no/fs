import { glob } from 'glob';
import { resolve, dirname, basename } from 'path';
import { readFileSync, writeFileSync } from 'fs';
import { parseFeatureFile } from './parser.js';

const KRAV_ROOT = resolve(import.meta.dirname, '../../krav');
const OUTPUT_FILE = resolve(KRAV_ROOT, 'krav-oversikt.md');

interface FeatureEntry {
  id: string;
  featureName: string;
  subdomain: string;
  capability: string;
  tags: string;
  filePath: string;
  fileName: string;
  domain: string;
  domainSortOrder: number;
}

function extractFolderInfo(folderName: string): { name: string; sortOrder: number } {
  const match = folderName.match(/^(\d+)\s+(.+)$/);
  if (match) {
    return {
      sortOrder: parseInt(match[1], 10),
      name: match[2],
    };
  }
  return { sortOrder: 0, name: folderName };
}

function extractIdFromTags(filePath: string): string | null {
  const content = readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');

  // ID pattern: @DOM-SUB-KAP-NN or @DOM-SUB-KAP-NNN (e.g., @OPP-FOR-REG-01 or @OPT-REG-GRU-001)
  const idPattern = /^@([A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{2,3})$/;

  for (const line of lines) {
    const trimmed = line.trim();

    // Stop if we hit the Feature/Egenskap line
    if (trimmed.startsWith('Egenskap:') || trimmed.startsWith('Feature:')) {
      break;
    }

    // Check each tag on the line
    if (trimmed.startsWith('@')) {
      const tags = trimmed.split(/\s+/);
      for (const tag of tags) {
        const match = tag.match(idPattern);
        if (match) {
          return match[1];
        }
      }
    }
  }

  return null;
}

function extractRawTags(filePath: string): string {
  const content = readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');

  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith('@')) {
      return trimmed;
    }
    // Stop if we hit the Feature/Egenskap line
    if (trimmed.startsWith('Egenskap:') || trimmed.startsWith('Feature:')) {
      break;
    }
  }

  return '';
}

function fileContainsTag(filePath: string, tag: string): boolean {
  const content = readFileSync(filePath, 'utf-8');
  return content.includes(tag);
}

function extractPathInfo(relativePath: string): {
  domain: string;
  domainSortOrder: number;
  subdomain: string;
  capability: string;
} {
  const dirPath = dirname(relativePath);
  const parts = dirPath.split('/').filter((p: string) => p && p !== '.');

  const domain = parts[0] || '';
  const domainInfo = extractFolderInfo(domain);
  const subdomain = parts[1] || '';
  const capability = parts[2] || '';

  return {
    domain,
    domainSortOrder: domainInfo.sortOrder,
    subdomain,
    capability,
  };
}

async function main(): Promise<void> {
  console.log('Finding .feature files...');

  const files = await glob('**/*.feature', {
    cwd: KRAV_ROOT,
    absolute: false,
  });

  console.log(`Found ${files.length} .feature files`);

  const entries: FeatureEntry[] = [];
  let levertCount = 0;
  let skipCount = 0;

  for (const relativePath of files) {
    const absolutePath = resolve(KRAV_ROOT, relativePath);
    const parsed = parseFeatureFile(absolutePath, KRAV_ROOT);

    const rawTags = extractRawTags(absolutePath);

    // Count statistics - search entire file like bash script did
    if (fileContainsTag(absolutePath, '@levert')) {
      levertCount++;
    }
    if (fileContainsTag(absolutePath, '@skip')) {
      skipCount++;
    }

    const id = extractIdFromTags(absolutePath) || '';
    const pathInfo = extractPathInfo(relativePath);

    entries.push({
      id,
      featureName: parsed?.feature.name || '',
      subdomain: pathInfo.subdomain,
      capability: pathInfo.capability,
      tags: rawTags,
      filePath: relativePath,
      fileName: basename(relativePath),
      domain: pathInfo.domain,
      domainSortOrder: pathInfo.domainSortOrder,
    });
  }

  // Sort by domain sort_order, then by file path
  entries.sort((a, b) => {
    if (a.domainSortOrder !== b.domainSortOrder) {
      return a.domainSortOrder - b.domainSortOrder;
    }
    return a.filePath.localeCompare(b.filePath);
  });

  // Generate markdown
  const lines: string[] = [];
  lines.push('# Kravoversikt');
  lines.push('');
  lines.push('Generert oversikt over alle BDD-krav i prosjektet.');
  lines.push('');

  let currentDomain = '';

  for (const entry of entries) {
    if (entry.domain !== currentDomain) {
      currentDomain = entry.domain;
      lines.push('');
      lines.push(`## ${entry.domain}`);
      lines.push('');
      lines.push('| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |');
      lines.push('|----|---------|------------|-------------|------|-----|');
    }

    // URL-encode the path (replace spaces with %20)
    const encodedPath = entry.filePath.replace(/ /g, '%20');

    lines.push(
      `| ${entry.id} | ${entry.featureName} | ${entry.subdomain} | ${entry.capability} | ${entry.tags} | [${entry.fileName}](${encodedPath}) |`
    );
  }

  // Statistics section
  lines.push('');
  lines.push('## Statistikk');
  lines.push('');
  lines.push(`- Totalt: ${entries.length}`);
  lines.push(`- Levert: ${levertCount}`);
  lines.push(`- Skip: ${skipCount}`);
  lines.push('');

  const output = lines.join('\n');
  writeFileSync(OUTPUT_FILE, output);

  console.log(`Generated ${OUTPUT_FILE}`);
  console.log(`Statistics: ${entries.length} total, ${levertCount} levert, ${skipCount} skip`);
}

main().catch(console.error);
