import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import { createGraphQLClient, GraphQLResponse } from '../fixtures/graphql';
import { HENT_ORGANISASJONER } from '../queries/organisasjon';

const { Given, When, Then } = createBdd();

let graphqlResponse: GraphQLResponse;

When('jeg henter liste over organisasjoner fra GraphQL', async ({ request }) => {
  const client = createGraphQLClient(request);
  graphqlResponse = await client.query(HENT_ORGANISASJONER, { first: 10 });
});

Then('skal responsen inneholde organisasjoner', async () => {
  expect(graphqlResponse.errors).toBeUndefined();
  expect(graphqlResponse.data).toBeDefined();
});

Then('hver organisasjon skal ha et navn', async () => {
  const data = graphqlResponse.data as {
    organisasjoner?: {
      edges?: Array<{
        node: {
          navnAlleSprak: { nb?: string; nn?: string; en?: string }
        }
      }>
    }
  };
  const edges = data?.organisasjoner?.edges;

  expect(edges).toBeDefined();
  expect(Array.isArray(edges)).toBe(true);

  if (edges && edges.length > 0) {
    for (const edge of edges) {
      expect(edge.node.navnAlleSprak).toBeDefined();
    }
  }
});

When('jeg kjører en introspection query', async ({ request }) => {
  const client = createGraphQLClient(request);
  graphqlResponse = await client.query(`
    query IntrospectionQuery {
      __schema {
        types {
          name
          kind
        }
      }
    }
  `);
});

Then('skal responsen inneholde schema-informasjon', async () => {
  expect(graphqlResponse.errors).toBeUndefined();
  expect(graphqlResponse.data).toBeDefined();

  const data = graphqlResponse.data as { __schema?: { types?: Array<{ name: string }> } };
  expect(data?.__schema?.types).toBeDefined();
  expect(Array.isArray(data?.__schema?.types)).toBe(true);
});
