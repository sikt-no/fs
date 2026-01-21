import * as Gherkin from '@cucumber/gherkin';
import * as Messages from '@cucumber/messages';
import { readFileSync } from 'fs';
import { basename, dirname, relative } from 'path';
import type { ParsedFeature } from './types.js';

const STATUS_TAGS = ['implemented', 'in-progress', 'planned'];
const PRIORITY_TAGS = ['must', 'should', 'could', 'wont'];

// Feature-ID pattern: XXX-XXX-XXX-NNN (3 letters each segment, 3 digits)
// Supports Norwegian characters (Æ, Ø, Å)
const FEATURE_ID_PATTERN = /^[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{3}$/i;

function extractFolderInfo(folderName: string): { name: string; sort_order: number } {
  // Extract number prefix and name from folder like "02 Opptak"
  const match = folderName.match(/^(\d+)\s+(.+)$/);
  if (match) {
    return {
      sort_order: parseInt(match[1], 10),
      name: match[2],
    };
  }
  return { sort_order: 0, name: folderName };
}

function extractTags(tags: readonly Messages.Tag[]): {
  featureId: string | null;
  status: string | null;
  priority: string | null;
  otherTags: string[];
} {
  let featureId: string | null = null;
  let status: string | null = null;
  let priority: string | null = null;
  const otherTags: string[] = [];

  for (const tag of tags) {
    const tagName = tag.name.replace('@', '');
    const tagNameLower = tagName.toLowerCase();

    // Check for Feature-ID pattern first
    if (FEATURE_ID_PATTERN.test(tagName)) {
      featureId = tagName.toUpperCase();
    } else if (STATUS_TAGS.includes(tagNameLower)) {
      status = tagNameLower;
    } else if (PRIORITY_TAGS.includes(tagNameLower)) {
      priority = tagNameLower;
    } else {
      otherTags.push(tag.name);
    }
  }

  return { featureId, status, priority, otherTags };
}

function extractOpenQuestions(comments: readonly Messages.Comment[]): string[] {
  const questions: string[] = [];
  let inOpenQuestionsBlock = false;

  for (const comment of comments) {
    const text = comment.text.trim();

    // Check if we're entering an OPEN QUESTIONS block
    if (text.match(/^#?\s*(OPEN QUESTIONS|ÅPNE SPØRSMÅL):?\s*$/i)) {
      inOpenQuestionsBlock = true;
      continue;
    }

    // Check for question lines (starting with "# -")
    if (inOpenQuestionsBlock) {
      const questionMatch = text.match(/^#?\s*-\s*(.+)$/);
      if (questionMatch) {
        questions.push(questionMatch[1].trim());
      } else if (text.match(/^#?\s*$/)) {
        // Empty comment line, continue in block
        continue;
      } else if (!text.startsWith('#')) {
        // Non-comment line, exit block
        inOpenQuestionsBlock = false;
      }
    }
  }

  return questions;
}

export function parseFeatureFile(filePath: string, kravRoot: string): ParsedFeature | null {
  const content = readFileSync(filePath, 'utf-8');

  // Parse with Gherkin
  const uuidFn = Messages.IdGenerator.uuid();
  const builder = new Gherkin.AstBuilder(uuidFn);
  const matcher = new Gherkin.GherkinClassicTokenMatcher('no'); // Norwegian
  const parser = new Gherkin.Parser(builder, matcher);

  let gherkinDocument: Messages.GherkinDocument;
  try {
    gherkinDocument = parser.parse(content);
  } catch (error) {
    console.error(`Failed to parse ${filePath}:`, error);
    return null;
  }

  const feature = gherkinDocument.feature;
  if (!feature) {
    console.warn(`No feature found in ${filePath}`);
    return null;
  }

  // Extract domain, subdomain, and capability from path
  const relativePath = relative(kravRoot, filePath);
  const parts = dirname(relativePath).split('/').filter(p => p && p !== '.');

  if (parts.length === 0) {
    console.warn(`File ${filePath} is not in a domain folder`);
    return null;
  }

  const domainFolder = parts[0];
  const subdomainFolder = parts.length > 1 ? parts[1] : null;
  const capabilityFolder = parts.length > 2 ? parts[2] : null;

  const domainInfo = extractFolderInfo(domainFolder);
  const subdomainInfo = subdomainFolder ? extractFolderInfo(subdomainFolder) : null;
  const capabilityInfo = capabilityFolder ? extractFolderInfo(capabilityFolder) : null;

  // Extract tags including Feature-ID
  const { featureId, status, priority, otherTags } = extractTags(feature.tags);

  // Validate Feature-ID exists
  if (!featureId) {
    console.warn(`WARNING: No Feature-ID found in ${filePath}`);
  }

  // Extract background steps (to prepend to all scenarios)
  let backgroundSteps: { keyword: string; text: string }[] = [];

  // Process children (Background, Rules, Scenarios)
  const rules: ParsedFeature['rules'] = [];
  const scenarios: ParsedFeature['scenarios'] = [];

  for (const child of feature.children) {
    if (child.background) {
      backgroundSteps = child.background.steps.map(step => ({
        keyword: step.keyword.trim(),
        text: step.text,
      }));
    } else if (child.rule) {
      const ruleScenarios: ParsedFeature['rules'][0]['scenarios'] = [];

      for (const ruleChild of child.rule.children) {
        if (ruleChild.scenario) {
          const scenario = ruleChild.scenario;
          const scenarioTags = extractTags(scenario.tags);
          const steps = [
            ...backgroundSteps,
            ...scenario.steps.map(step => ({
              keyword: step.keyword.trim(),
              text: step.text,
            })),
          ];

          ruleScenarios.push({
            name: scenario.name,
            status: scenarioTags.status,
            priority: scenarioTags.priority,
            tags: scenarioTags.otherTags,
            steps,
          });
        }
      }

      const ruleTags = extractTags(child.rule.tags);
      rules.push({
        name: child.rule.name,
        status: ruleTags.status,
        priority: ruleTags.priority,
        scenarios: ruleScenarios,
      });
    } else if (child.scenario) {
      const scenario = child.scenario;
      const scenarioTags = extractTags(scenario.tags);
      const steps = [
        ...backgroundSteps,
        ...scenario.steps.map(step => ({
          keyword: step.keyword.trim(),
          text: step.text,
        })),
      ];

      scenarios.push({
        name: scenario.name,
        status: scenarioTags.status,
        priority: scenarioTags.priority,
        tags: scenarioTags.otherTags,
        steps,
      });
    }
  }

  // Extract open questions from comments
  const openQuestions = extractOpenQuestions(gherkinDocument.comments);

  return {
    filePath: relativePath,
    domain: {
      folder_name: domainFolder,
      ...domainInfo,
    },
    subdomain: subdomainInfo ? {
      folder_name: subdomainFolder!,
      ...subdomainInfo,
    } : null,
    capability: capabilityInfo ? {
      folder_name: capabilityFolder!,
      ...capabilityInfo,
    } : null,
    feature: {
      feature_id: featureId,
      name: feature.name,
      description: feature.description?.trim() || null,
      status,
      priority,
      tags: otherTags,
    },
    rules,
    scenarios,
    openQuestions,
  };
}
