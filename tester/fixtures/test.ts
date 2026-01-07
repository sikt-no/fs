import { test as base } from 'playwright-bdd';
import { createGraphQLClient, GraphQLClient } from './graphql';

/**
 * Utvidet test fixture med GraphQL-klient
 */
export const test = base.extend<{
  graphql: GraphQLClient;
}>({
  graphql: async ({ request }, use) => {
    const token = process.env.GRAPHQL_TOKEN;
    const client = createGraphQLClient(request, token);
    await use(client);
  },
});

export { expect } from '@playwright/test';
