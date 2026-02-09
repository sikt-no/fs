import { createBdd } from 'playwright-bdd';
import { expect } from '@playwright/test';
import { hentUtdanningsinstanser } from '../graphql/client';
import type { AdmissioUtdanningsinstans } from '../graphql/types';

const { When, Then } = createBdd();

let utdanningsinstanser: AdmissioUtdanningsinstans[];
let graphqlError: Error | undefined;

When('jeg henter liste over utdanningsinstanser fra GraphQL', async ({ request }) => {
  try {
    utdanningsinstanser = await hentUtdanningsinstanser(request);
    graphqlError = undefined;
  } catch (error) {
    graphqlError = error as Error;
  }
});

Then('skal responsen ikke inneholde feil', async () => {
  expect(graphqlError).toBeUndefined();
});

Then('skal hver utdanningsinstans inneholde følgende felt', async ({}, dataTable: { rows: () => string[][] }) => {
  expect(utdanningsinstanser).toBeDefined();
  expect(utdanningsinstanser.length).toBeGreaterThan(0);

  const felter = dataTable.rows().map(row => row[0]);

  for (const instans of utdanningsinstanser) {
    for (const felt of felter) {
      const verdi = (instans as Record<string, unknown>)[felt];
      expect(verdi, `Felt '${felt}' = ${JSON.stringify(verdi)}`).toBeDefined();
    }
  }
});
