import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';

const { Given, When, Then } = createBdd();

Given('at brukeren er på todo-liste siden', async ({ page }) => {
  // Gå til siden først for å få tilgang til localStorage
  await page.goto('https://eviltester.github.io/simpletodolist/todolists.html');
  // Tøm localStorage
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });
  // Reload for å starte med tom liste
  await page.reload();
  // Vent på at listen er tom
  await page.waitForSelector('ul.todo-list-list');
});

When('brukeren skriver {string} i input-feltet', async ({ page }, tekst: string) => {
  await page.locator('input.new-todo-list').fill(tekst);
});

When('brukeren trykker på legg til-knappen', async ({ page }) => {
  await page.locator('input.new-todo-list').press('Enter');
});

Then('skal {string} vises i listen', async ({ page }, tekst: string) => {
  // Appen konverterer mellomrom til bindestrek
  const forventetTekst = tekst.replace(/ /g, '-');
  await expect(page.locator('ul.todo-list-list li').filter({ hasText: forventetTekst })).toBeVisible();
});

When('brukeren legger til følgende oppgaver', async ({ page }, dataTable) => {
  const oppgaver = dataTable.rows().map((row: string[]) => row[0]);
  for (const oppgave of oppgaver) {
    await page.locator('input.new-todo-list').fill(oppgave);
    await page.locator('input.new-todo-list').press('Enter');
  }
});

Then('skal listen inneholde {int} oppgaver', async ({ page }, antall: number) => {
  await expect(page.locator('ul.todo-list-list li')).toHaveCount(antall);
});
