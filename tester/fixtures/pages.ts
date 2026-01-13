import { test as base } from '@playwright/test';
import { FsAdminLoginPage } from '../pages/FsAdminLoginPage';

type Pages = {
  fsAdminLoginPage: FsAdminLoginPage;
};

export const test = base.extend<Pages>({
  fsAdminLoginPage: async ({ page }, use) => {
    await use(new FsAdminLoginPage(page));
  },
});

export { expect } from '@playwright/test';
