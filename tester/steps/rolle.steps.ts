import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/auth'

const { Given } = createBdd(test)

Given('at jeg er logget inn som administrator', async ({ adminPage }) => {
  await expect(adminPage).not.toHaveURL(/login/)
})

Given('at jeg er logget inn som person', async ({ personPage }) => {
  await expect(personPage).not.toHaveURL(/login/)
})