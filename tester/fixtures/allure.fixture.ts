import { test as base } from 'playwright-bdd';
import { severity, label, tag, feature, story, Severity } from 'allure-js-commons';

/**
 * Custom fixture that automatically maps BDD tags to Allure metadata
 *
 * Tags supported:
 * - @must, @should, @could, @wont → Severity
 * - @implemented, @in-progress, @planned → Custom label
 * - @e2e, @integration, @demo → Tags
 */
export const test = base.extend<{
  autoAllureMetadata: void;
}>({
  autoAllureMetadata: [async ({ $testInfo, $tags }, use) => {
    // Map MoSCoW priority tags to Allure severity
    const severityMap: Record<string, Severity> = {
      '@must': Severity.CRITICAL,
      '@should': Severity.NORMAL,
      '@could': Severity.MINOR,
      '@wont': Severity.TRIVIAL,
    };

    // Map status tags
    const statusTags = ['@implemented', '@in-progress', '@planned'];

    // Map test type tags
    const typeTags = ['@e2e', '@integration', '@demo'];

    for (const t of $tags) {
      // Apply severity
      if (severityMap[t]) {
        await severity(severityMap[t]);
      }

      // Apply status as custom label
      if (statusTags.includes(t)) {
        await label('status', t.replace('@', ''));
      }

      // Apply test type as tag
      if (typeTags.includes(t)) {
        await tag(t.replace('@', ''));
      }
    }

    // Extract feature/story from test title path
    const titlePath = $testInfo.titlePath;
    if (titlePath.length >= 2) {
      // First part is typically the feature name
      await feature(titlePath[0]);
    }
    if (titlePath.length >= 3) {
      // Second part could be a rule
      await story(titlePath[1]);
    }

    await use();
  }, { auto: true }],
});

export { expect } from '@playwright/test';
