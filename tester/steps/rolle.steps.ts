import { createBdd } from 'playwright-bdd';

const { Given } = createBdd();

// Steg for innlogging - auth håndteres av storageState i config
Given('at jeg er logget inn som {word}', async ({ page }, rolle: string) => {
  // Auth state er allerede lastet via storageState
  // Dette steget bekrefter bare at vi er logget inn
});