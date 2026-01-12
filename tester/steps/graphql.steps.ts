import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';

const { When, Then } = createBdd();

if (!process.env.GRAPHQL_ENDPOINT) {
  throw new Error('GRAPHQL_ENDPOINT environment variable is required');
}
const GRAPHQL_ENDPOINT = process.env.GRAPHQL_ENDPOINT;

interface GraphQLResponse {
  data?: Record<string, unknown>;
  errors?: Array<{ message: string }>;
}

let graphqlResponse: GraphQLResponse;

When('jeg henter liste over utdanningsinstanser fra GraphQL', async ({ request }) => {
  const response = await request.post(GRAPHQL_ENDPOINT, {
    headers: { 'Content-Type': 'application/json' },
    data: {
      query: `
        query HentUtdanningsinstanser {
          admissioUtdanningsinstanser {
            id
            organisasjon {
              navn {
                nb
              }
            }
            terminFra {
              arstall
            }
            terminTil {
              arstall
            }
          }
        }
      `,
    },
  });

  graphqlResponse = await response.json();
});

Then('skal responsen ikke inneholde feil', async () => {
  expect(graphqlResponse.errors).toBeUndefined();
});

Then('skal hver utdanningsinstans inneholde følgende felt', async ({}, dataTable: { rows: () => string[][] }) => {
  const data = graphqlResponse.data as {
    admissioUtdanningsinstanser?: Array<Record<string, unknown>>;
  };

  const instanser = data.admissioUtdanningsinstanser;
  expect(instanser).toBeDefined();
  expect(instanser!.length).toBeGreaterThan(0);

  const felter = dataTable.rows().map(row => row[0]);

  for (const instans of instanser!) {
    for (const felt of felter) {
      const verdi = instans[felt];
      expect(verdi, `Felt '${felt}' = ${JSON.stringify(verdi)}`).toBeDefined();
    }
  }
});
