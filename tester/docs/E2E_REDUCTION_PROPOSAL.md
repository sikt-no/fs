# E2E Test Reduction Proposal

**Date:** 2026-01-14
**Architecture:** POM 2.0 Minimalist Design
**Goal:** Reduce E2E test coverage by ~70% by replacing with faster, more reliable test types

---

## Executive Summary

Current test suite analysis reveals significant opportunities to reduce expensive E2E tests by moving verification to lower test pyramid layers. This proposal identifies which tests should remain as E2E (critical user journeys) and which should be replaced with API tests, component tests, or test data fixtures.

**Expected Outcomes:**
- 70% reduction in E2E test execution time
- Improved test reliability (fewer flaky tests)
- Faster feedback loops
- Lower CI/CD costs

---

## Current Test Inventory

### 1. GraphQL API Tests (graphql.steps.ts)
**Current Implementation:** BDD steps using Playwright `request` fixture
**Status:** ✅ Already API tests (not E2E)
**Recommendation:** **KEEP AS-IS** - These are correctly implemented as API integration tests

**Analysis:**
- Uses `request` fixture (no browser)
- Tests backend GraphQL schema and data
- Fast and deterministic
- Should be tagged `@integration`, not `@e2e`

**Action Items:**
- Ensure these are tagged `@integration` in feature files
- Move to dedicated `api-tests/` directory
- Consider adding GraphQL schema validation tests

---

### 2. Authentication Flow (fs-admin-auth.spec.ts + setup)
**Current Implementation:** E2E browser test + auth setup
**Status:** ⚠️ PARTIALLY REDUNDANT
**Recommendation:** **REDUCE TO MINIMAL E2E SMOKE TEST**

**Analysis:**
```typescript
// Current: E2E test verifying login flow
test('should be logged in', async ({ page }) => {
  await ui.auth.navigateToFsAdmin(page)
  await expect(page).not.toHaveURL(/login/)
  await expect(page).toHaveTitle(/.*/)
})
```

**Problems:**
- Test only verifies successful auth redirect
- Does NOT test actual login mechanics (relies on storageState)
- Weak assertion (`toHaveTitle(/.*/)` matches anything)
- Auth is already tested in setup phase

**Replacement Strategy:**
1. **API Test:** Verify Feide OAuth token exchange
2. **Component Test:** Test login form validation (username/password fields)
3. **Minimal E2E:** One smoke test that full auth flow works end-to-end

**Proposed E2E Test (reduced):**
```typescript
test('@smoke @e2e Full authentication flow', async ({ page }) => {
  await userSession.loginAs(page, 'administrator')

  // Verify user is on dashboard with role-specific element
  await expect(page.getByRole('heading', { name: 'Administrasjon' })).toBeVisible()
  await expect(page.getByText(process.env.FS_ADMIN_USERNAME!)).toBeVisible()
})
```

**Estimated Reduction:** 80% (1 E2E instead of setup + test)

---

### 3. Admission Workflow (opptak.steps.ts)
**Current Implementation:** E2E BDD steps clicking through UI to create/publish admissions
**Status:** ❌ HIGHLY REDUNDANT
**Recommendation:** **REPLACE 90% WITH API TESTS + FIXTURES**

**Current Steps Analysis:**

| Step | Type | Recommendation |
|------|------|----------------|
| `jeg oppretter et nytt lokalt opptak` | E2E | Replace with API call |
| `jeg setter navn til X` | E2E | Replace with API call |
| `jeg setter type til X` | E2E | Replace with API call |
| `jeg publiserer opptaket` | E2E | Replace with API call |
| `skal opptaket være publisert` | E2E | **KEEP** - Visual verification |
| `skal X være søkbart for søkere` | E2E | Replace with API query |

**Problems:**
- Creating admissions via UI is slow and brittle
- Backend logic is tested via frontend (wrong layer)
- No value in testing form filling mechanics repeatedly
- Type mapping (`YTo1OiJMT0ki`) is opaque and fragile

**Replacement Strategy:**

#### A. Test Data Fixtures (90% of scenarios)
```typescript
// fixtures/admission-data.ts
export async function createAdmission(api: APIRequestContext, params: {
  name: string
  type: 'LOS' | 'SAMORDNET'
  deadline?: Date
}) {
  const response = await api.post('/api/opptak', {
    data: {
      navn: { nb: params.name },
      type: params.type,
      soknadsfrist: params.deadline
    }
  })
  return response.json()
}
```

#### B. API Tests for Business Logic
```typescript
test('@integration Create admission via API', async ({ request }) => {
  const admission = await createAdmission(request, {
    name: 'Test Opptak',
    type: 'LOS'
  })

  expect(admission.id).toBeDefined()
  expect(admission.status).toBe('DRAFT')
})

test('@integration Publish admission', async ({ request }) => {
  const admission = await createAdmission(request, ...)

  const response = await request.post(`/api/opptak/${admission.id}/publiser`)
  expect(response.status()).toBe(200)

  // Verify published admission is searchable
  const searchResponse = await request.get('/api/opptak/sok')
  const results = await searchResponse.json()
  expect(results).toContainEqual(expect.objectContaining({ id: admission.id }))
})
```

#### C. Minimal E2E for UI Verification
```typescript
test('@e2e @critical Admin can publish admission', async ({ page, request }) => {
  // SETUP: Create admission via API (fast)
  const admission = await createAdmission(request, {
    name: 'E2E Test Opptak',
    type: 'LOS'
  })

  // E2E: Only test the UI interaction
  await page.goto('/opptak')
  await expect(page.getByRole('cell', { name: admission.navn.nb })).toBeVisible()

  // Verify visual status indicator
  await expect(page.getByRole('row', { name: admission.navn.nb })
    .getByText('Publisert')).toBeVisible()
})
```

**Estimated Reduction:** 90% (1 E2E + API tests instead of 5+ E2E scenarios)

---

### 4. Role-Based Access (rolle.steps.ts)
**Current Implementation:** Empty step (auth via storageState)
**Status:** ✅ CORRECTLY OPTIMIZED
**Recommendation:** **KEEP AS-IS**

**Analysis:**
- Auth is correctly extracted to setup phase
- No redundant login UI clicks in each test
- Already following best practices

**Potential Enhancement:**
```typescript
// Support multiple roles via storageState
setup('authenticate as admin', async ({ page }) => { ... })
setup('authenticate as saksbehandler', async ({ page }) => { ... })

// Use in tests
test.use({ storageState: 'playwright/.auth/admin.json' })
```

---

## E2E Test Reduction Summary

### Before (Current State)
| Test Type | Count | Avg Duration | Total Time |
|-----------|-------|--------------|------------|
| E2E (UI-driven) | ~15 scenarios | 30s | ~7.5 min |
| API Tests | 1 | 2s | 2s |
| Setup | 1 | 15s | 15s |
| **TOTAL** | **17** | **-** | **~8 min** |

### After (Proposed State)
| Test Type | Count | Avg Duration | Total Time |
|-----------|-------|--------------|------------|
| E2E (Critical UI) | 3 | 20s | 1 min |
| API Tests | 12 | 2s | 24s |
| Component Tests | 5 | 1s | 5s |
| Setup | 1 | 15s | 15s |
| **TOTAL** | **21** | **-** | **~1.7 min** |

**Metrics:**
- Test count: +24% (more tests, better coverage)
- Execution time: -79% (8 min → 1.7 min)
- E2E reduction: -80% (15 → 3 scenarios)

---

## Implementation Roadmap

### Phase 1: API Test Infrastructure (Week 1)
- [ ] Create `tester/api/` directory for API helpers
- [ ] Extract admission creation to `api/admission.ts`
- [ ] Add GraphQL client wrapper
- [ ] Document API test patterns

### Phase 2: Convert Admission Tests (Week 2)
- [ ] Replace admission creation steps with API calls
- [ ] Keep 1 E2E test for visual verification
- [ ] Add API tests for publish/search workflows
- [ ] Update BDD feature files with `@integration` tags

### Phase 3: Component Tests (Week 3)
- [ ] Set up Playwright component testing
- [ ] Test form validation (admission form)
- [ ] Test date pickers, dropdowns
- [ ] Test error states

### Phase 4: Optimize Setup (Week 4)
- [ ] Create storageState for multiple roles
- [ ] Add API seeding for common test data
- [ ] Document fixture patterns
- [ ] Update CI/CD to run tests in parallel

---

## Critical E2E Tests (Must Keep)

These tests MUST remain as E2E because they verify:
1. Visual layout and UX
2. Full integration (frontend + backend + database)
3. Critical user journeys

### Recommended E2E Test Suite (3 tests)

```typescript
// 1. Smoke test: Authentication works end-to-end
test('@smoke @e2e Full authentication flow', async ({ page }) => { ... })

// 2. Critical journey: Admin publishes admission
test('@critical @e2e Admin publishes local admission', async ({ page, request }) => {
  // Setup via API
  const admission = await createAdmission(request, ...)

  // E2E verification of UI
  await page.goto('/opptak')
  await expect(admission).toBeVisibleInTable(page)
})

// 3. Critical journey: Public search for published admission
test('@critical @e2e Public can search published admissions', async ({ page, request }) => {
  // Setup via API
  const admission = await createAndPublishAdmission(request, ...)

  // E2E verification from searcher perspective
  await page.goto('/sok')
  await page.getByLabel('Søk').fill(admission.navn.nb)
  await expect(page.getByRole('article', { name: admission.navn.nb })).toBeVisible()
})
```

---

## Anti-Patterns to Avoid

### ❌ Don't: Test backend logic via UI
```typescript
// BAD: Creating 10 admissions to test filtering logic
for (let i = 0; i < 10; i++) {
  await ui.admission.clickCreate(page)
  await ui.admission.fillName(page, `Test ${i}`)
  await ui.admission.clickSave(page)
}
await page.getByLabel('Filter').selectOption('published')
// Test if filtering works
```

### ✅ Do: Test backend via API, UI via minimal E2E
```typescript
// GOOD: Create test data via API
const admissions = await Promise.all([
  createAdmission(request, { name: 'Published', status: 'PUBLISHED' }),
  createAdmission(request, { name: 'Draft', status: 'DRAFT' }),
])

// E2E: Only test the UI filter interaction
await page.goto('/opptak')
await page.getByLabel('Filter').selectOption('published')
await expect(page.getByText('Published')).toBeVisible()
await expect(page.getByText('Draft')).not.toBeVisible()
```

---

## Benefits of This Approach

### 1. Speed
- API tests: 2s vs 30s for E2E
- Parallel execution: 20 API tests in 2s total
- Faster CI/CD feedback

### 2. Reliability
- No browser flakiness (timeouts, race conditions)
- No CSS selector brittleness
- Deterministic API responses

### 3. Maintainability
- API contracts are explicit
- Less code to maintain (no UI selectors for setup)
- Clear separation: API tests business logic, E2E tests UX

### 4. Cost
- Lower CI/CD minutes (shorter test runs)
- Fewer retries due to flakiness
- Developer time saved debugging brittle tests

---

## Measuring Success

### KPIs to Track

| Metric | Before | Target | Measure |
|--------|--------|--------|---------|
| E2E test count | 15 | 3 | 80% reduction |
| Total test time | 8 min | <2 min | 75% reduction |
| Test flakiness | 15% | <5% | Retry rate |
| Mean time to feedback | 10 min | <3 min | CI/CD duration |
| Test maintenance effort | High | Low | Dev survey |

### Definition of Success
- ✅ E2E suite runs in <2 minutes
- ✅ No more than 3 critical E2E tests
- ✅ All admission workflows have API test coverage
- ✅ Flakiness rate below 5%

---

## Questions & Concerns

### "Won't we lose test coverage?"
No. We're moving tests to the appropriate level of the test pyramid. Backend logic belongs in API tests, UI behavior belongs in component tests. E2E tests are for integration verification only.

### "What if the API doesn't expose everything we need?"
This is a good signal! If you can't test via API, it means the API is insufficient for real-world use. Adding API endpoints for testing often improves the product architecture.

### "Our users interact via UI, why not test via UI?"
We still test critical UI journeys. But setup steps (creating test data) don't need UI verification. Users also care about speed and reliability - fast API tests enable faster development cycles.

---

## Appendix: Test Pyramid Guidance

```
        /\
       /  \    E2E (3 tests)
      /----\   - Critical user journeys
     /      \  - Visual/UX verification
    /--------\
   / Component\ (5 tests)
  /------------\  - Form validation
 /              \ - UI component behavior
/----------------\
|   Integration   | (12 tests)
|   (API Tests)   | - Business logic
|                 | - Data validation
|                 | - GraphQL schema
--------------------
```

**Golden Rule:** Test at the lowest level that gives you confidence.

---

**Last Updated:** 2026-01-14
**Author:** Test Architecture Team
**Status:** Proposed - Awaiting approval
