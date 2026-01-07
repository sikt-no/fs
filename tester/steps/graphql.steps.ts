import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import { createGraphQLClient, GraphQLResponse } from '../fixtures/graphql';
import { HENT_UTDANNINGSINSTANSER } from '../queries/utdanning';

const { When, Then } = createBdd();

let graphqlResponse: GraphQLResponse;

// Utdanningsinstanser
When('jeg henter liste over utdanningsinstanser fra GraphQL', async ({ request }) => {
  const client = createGraphQLClient(request);
  graphqlResponse = await client.query(HENT_UTDANNINGSINSTANSER);
});

Then('skal responsen ikke inneholde feil', async () => {
  expect(graphqlResponse.errors).toBeUndefined();
});

Then('skal responsen inneholde utdanningsinstanser', async () => {
  expect(graphqlResponse.data).toBeDefined();
  const data = graphqlResponse.data as { admissioUtdanningsinstanser?: unknown[] };
  expect(data.admissioUtdanningsinstanser).toBeDefined();
  expect(Array.isArray(data.admissioUtdanningsinstanser)).toBe(true);
});

Then('hver utdanningsinstans skal ha organisasjon, campus og terminer', async () => {
  const data = graphqlResponse.data as {
    admissioUtdanningsinstanser?: Array<{
      id: string;
      campus?: { navn?: { nb?: string } };
      organisasjon?: { navn?: { nb?: string } };
      terminFra?: { arstall?: number };
      terminTil?: { arstall?: number };
    }>;
  };

  const instanser = data.admissioUtdanningsinstanser;
  expect(instanser).toBeDefined();
  expect(instanser!.length).toBeGreaterThan(0);

  for (const instans of instanser!) {
    expect(instans.id).toBeDefined();
    expect(instans.organisasjon).toBeDefined();
    expect(instans.terminFra).toBeDefined();
    expect(instans.terminTil).toBeDefined();
  }
});

// Introspection
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
