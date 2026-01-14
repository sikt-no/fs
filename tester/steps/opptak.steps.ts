import { createBdd } from 'playwright-bdd';
import { expect } from '@playwright/test';

const { Given, When, Then } = createBdd();

// Lagrer sist opprettede opptak-navn for bruk i assertions
let sisteOpptakNavn: string;

Given('at jeg er på opptakssiden', async ({ page }) => {
  await page.goto('/opptak');
});

Given('at opptaket {string} er publisert', async ({ page }, opptakNavn: string) => {
  // TODO: Implementer sjekk eller opprett opptak
  await page.goto('/opptak');
});

When('jeg oppretter et nytt lokalt opptak', async ({ page }) => {
  await page.getByRole('link', { name: 'Velg Lokalt opptak' }).click();
});

When('jeg setter navn til {string}', async ({ page }, navn: string) => {
  sisteOpptakNavn = `${navn} - ${Date.now()}`;
  await page.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).click();
  await page.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).fill(sisteOpptakNavn);
});

When('jeg setter type til {string}', async ({ page }, type: string) => {
  // TODO: Map type-navn til value - nå hardkodet til "LOS"
  await page.getByLabel('Hvilken type lokalt opptak?').selectOption('YTo1OiJMT0si');
});

When('jeg setter søknadsfrist til {string}', async ({ page }, frist: string) => {
  // TODO: Implementer sett søknadsfrist
});

When('jeg setter oppstartsdato til {string}', async ({ page }, dato: string) => {
  // TODO: Implementer sett oppstartsdato
});

When('jeg publiserer opptaket', async ({ page }) => {
  await page.getByRole('button', { name: 'Lagre' }).click();
  await page.getByRole('link', { name: 'Avbryt' }).click();
});

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({ page }, utdanning: string) => {
  // TODO: Implementer tilknytning
});

Then('skal opptaket {string} være publisert', async ({ page }, _opptakNavn: string) => {
  await page.goto('/opptak');
  await expect(page.getByRole('cell', { name: sisteOpptakNavn })).toBeVisible();
});

Then('skal {string} være søkbart for søkere', async ({ page }, utdanning: string) => {
  // TODO: Implementer verifisering
});