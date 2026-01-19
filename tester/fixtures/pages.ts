import { test as base } from '@playwright/test';
import { FsAdminLoginPage } from '../pages/FsAdminLoginPage';
import { StudentLoginPage } from '../pages/StudentLoginPage';
import { FsAdminActions } from '../domain/FsAdminActions';
import { StudentActions } from '../domain/StudentActions';

type Fixtures = {
  fsAdminLoginPage: FsAdminLoginPage;
  studentLoginPage: StudentLoginPage;
  fsAdminActions: FsAdminActions;
  studentActions: StudentActions;
};

export const test = base.extend<Fixtures>({
  fsAdminLoginPage: async ({ page }, use) => {
    await use(new FsAdminLoginPage(page));
  },
  studentLoginPage: async ({ page }, use) => {
    await use(new StudentLoginPage(page));
  },
  fsAdminActions: async ({ page }, use) => {
    await use(new FsAdminActions(page));
  },
  studentActions: async ({ page }, use) => {
    await use(new StudentActions(page));
  },
});

export { expect } from '@playwright/test';
