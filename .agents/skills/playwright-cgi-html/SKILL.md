---
name: playwright-cgi-html
description: >
  Use this skill whenever the user wants to write, run, or debug Playwright tests
  for web applications — especially CGI-based, server-rendered HTML apps, or any
  HTTP-served frontend. Triggers include: "playwright", "E2E test", "CGI test",
  "HTML test", "integration test", "UI test", "browser test", "form test",
  "screenshot test", "page test". Also triggers when the user wants to test
  forms, navigation, dynamic content loaded via fetch/XHR, or CGI scripts
  returning HTML. Use for both generating new test files and diagnosing
  failures in existing ones.
---

# Playwright CGI/HTML Testing Skill

## Overview

This skill covers end-to-end (E2E) testing with Playwright for:
- Classic CGI applications (sh/Python/Perl scripts returning HTML)
- Server-rendered HTML pages with optional JavaScript enhancement
- REST-adjacent form POST → redirect → result page flows
- Any HTTP-accessible frontend regardless of backend language

---

## Environment Assumptions

| Item | Default | Override |
|------|---------|----------|
| Playwright version | 1.x (latest stable) | Check `playwright --version` |
| Node.js | ≥ 18 | Required for Playwright |
| Test runner | `@playwright/test` | Can also use bare `playwright` API |
| Browser | Chromium (headless) | `--browser firefox` / `webkit` |
| Base URL | `http://localhost` | Set in config `use.baseURL` |
| Test dir | `./tests/` | Configurable in `playwright.config.js` |

---

## Step 0: Discover the Project Layout

Before writing any test, confirm:

```bash
# Is playwright already installed?
playwright --version

# If not: install
npm init playwright@latest   # interactive setup, creates config + example tests
# OR minimal:
npm install -D @playwright/test
playwright install chromium   # download browser binaries
```

Check whether a `playwright.config.js` (or `.ts`) already exists:

```bash
ls playwright.config.*
```

If it exists, read it before generating tests — respect `baseURL`, `testDir`, timeouts.

---

## Step 1: Playwright Config

Generate or verify `playwright.config.js`:

```js
// playwright.config.js
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30_000,          // 30 s per test
  retries: process.env.CI ? 2 : 0,
  reporter: [
    ['html', { open: 'never' }],  // playwright show-report to view
    ['list'],                      // terminal output
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',
    headless: true,
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    // Add firefox / webkit as needed
  ],
});
```

Key variables the agent should infer from project context:
- `baseURL`: look for Apache/lighttpd/etc. config, `Makefile`, or README
- `testDir`: use `tests/` by default unless the project already has a convention
- `timeout`: increase to 60 000 for CGI apps on slow hardware (e.g., Raspberry Pi)

---

## Step 2: Test File Structure

One test file per page or feature area. Name pattern: `<feature>.spec.js`.

```
tests/
  add.spec.js          # /html/add.html + /cgi-bin/add.cgi
  search.spec.js       # /html/search.html + /cgi-bin/search.cgi
  list.spec.js         # /html/list.html  + /cgi-bin/list.cgi
  settings.spec.js     # /html/settings.html + /cgi-bin/settings.cgi
  navigation.spec.js   # nav links across all pages
```

### Standard test file skeleton

```js
// @ts-check
const { test, expect } = require('@playwright/test');

test.describe('Feature Name', () => {

  // Shared setup (runs before each test in this describe block)
  test.beforeEach(async ({ page }) => {
    await page.goto('/html/page.html');  // relative to baseURL
  });

  test('page renders correctly', async ({ page }) => {
    await expect(page).toHaveTitle(/Expected Title/);
    await expect(page.locator('h1')).toBeVisible();
  });

  test('form submission works', async ({ page }) => {
    await page.fill('input#field', 'value');
    await page.click('input[type="submit"]');
    // CGI redirect/response — wait for navigation
    await page.waitForURL(/cgi-bin\/handler\.cgi/);
    await expect(page.locator('.result')).toContainText('成功');
  });

});
```

---

## Step 3: Common Patterns

### 3-A: Form POST → CGI result page

```js
test('add book by ISBN', async ({ page }) => {
  await page.goto('/html/add.html');

  // Fill the form
  await page.fill('input#isbn', '9784873119076');

  // Toggle checkbox state (if needed)
  const toggle = page.locator('input[name="add_to_csv"]');
  if (!(await toggle.isChecked())) {
    await toggle.check();
  }

  // Submit and wait for CGI response page
  await Promise.all([
    page.waitForNavigation(),
    page.click('input[type="submit"]'),
  ]);

  await expect(page.locator('.result')).toBeVisible();
});
```

### 3-B: Async fetch / XHR content (JavaScript-enhanced pages)

When the page loads data via `fetch()` after DOMContentLoaded:

```js
test('list page loads data from CGI', async ({ page }) => {
  await page.goto('/html/list.html');

  // Wait until the dynamically-injected table appears
  await page.waitForSelector('table', { timeout: 10_000 });

  const rows = page.locator('table tbody tr');
  await expect(rows).toHaveCount(await rows.count()); // at least renders
});
```

Or wait for network idle:

```js
await page.goto('/html/list.html', { waitUntil: 'networkidle' });
```

### 3-C: Navigation links

```js
test('nav links reach correct pages', async ({ page }) => {
  await page.goto('/html/index.html');

  const links = [
    { text: '蔵書検索', urlPattern: /search\.html/ },
    { text: '蔵書一覧', urlPattern: /list\.html/ },
    { text: '書籍追加', urlPattern: /add\.html/ },
    { text: '設定',    urlPattern: /settings\.html/ },
  ];

  for (const { text, urlPattern } of links) {
    await page.goto('/html/index.html');
    await page.getByText(text, { exact: false }).first().click();
    await expect(page).toHaveURL(urlPattern);
  }
});
```

### 3-D: CGI error states

```js
test('search with no query shows error message', async ({ page }) => {
  // Bypass form validation by POSTing directly via request
  const response = await page.request.post('/cgi-bin/search.cgi', {
    form: { q: '' },
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
  });
  expect(response.status()).toBe(200);
  const body = await response.text();
  expect(body).toContain('検索ワードを入力してください');
});
```

### 3-E: Screenshot regression

```js
test('add page visual snapshot', async ({ page }) => {
  await page.goto('/html/add.html');
  await expect(page).toHaveScreenshot('add-page.png', {
    maxDiffPixelRatio: 0.02,  // allow 2% pixel difference
  });
});
```

First run creates the baseline; subsequent runs compare against it.

### 3-F: Settings persistence (CGI writes config file)

```js
test('settings save and reload', async ({ page }) => {
  await page.goto('/html/settings.html');

  await page.fill('input#csv_file', '/data/books.csv');
  await page.fill('input#code_server', 'http://localhost:8443');
  await page.click('button[type="submit"]');

  // CGI returns result page — look for success indicator
  await expect(page.locator('.result.success, .result')).toContainText('保存');

  // Reload settings page and verify values persisted
  await page.goto('/html/settings.html');
  await expect(page.locator('input#csv_file')).toHaveValue('/data/books.csv');
});
```

---

## Step 4: Running Tests

```bash
# Run all tests (headless)
playwright test

# Run a specific file
playwright test tests/add.spec.js

# Run with visible browser (headed) — useful for debugging
playwright test --headed

# Run in debug mode (opens Playwright Inspector)
playwright test --debug

# Filter by test name
playwright test -g "form submission"

# Show HTML report after run
playwright show-report
```

### Environment variable for base URL

```bash
BASE_URL=http://localhost:8888 playwright test
```

---

## Step 5: Diagnosing Failures

### Common failure patterns and fixes

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `Timeout waiting for selector` | Async JS hasn't resolved; CGI slow | Increase `timeout`; use `waitForSelector` |
| `net::ERR_CONNECTION_REFUSED` | Server not running | Start the server before tests |
| `404 on CGI` | Apache `mod_cgi` not enabled; wrong path | Verify `ScriptAlias` and permissions |
| `Expected 'success' got 'error'` | CGI returned error | Check CGI stderr, file permissions |
| Screenshot diff | CSS/font rendering differs across OS | Use `maxDiffPixelRatio` or run in Docker |
| `strict mode violation` | Multiple elements match selector | Use `.first()` or a more specific locator |

### Capture CGI response for debugging

```js
// Capture raw CGI output for inspection
const response = await page.request.post('/cgi-bin/add.cgi', {
  form: { isbn: '9784873119076', add_to_csv: 'yes' },
});
console.log(await response.text());
```

### Trace viewer

```bash
# After a failed test with trace: 'on-first-retry' set
playwright show-trace test-results/<test-dir>/trace.zip
```

---

## Step 6: CI Integration (optional)

### GitHub Actions example

```yaml
- name: Install Playwright
  run: playwright install --with-deps chromium

- name: Start web server
  run: |
    # Start your CGI server here, e.g.:
    python3 -m http.server 80 &
    sleep 2

- name: Run Playwright tests
  run: playwright test
  env:
    BASE_URL: http://localhost

- uses: actions/upload-artifact@v4
  if: failure()
  with:
    name: playwright-report
    path: playwright-report/
```

---

## Step 7: Selector Strategy (Priority Order)

Prefer selectors in this order — most resilient to UI changes first:

1. `page.getByRole('button', { name: '実行' })` — ARIA role + accessible name
2. `page.getByLabel('ISBN')` — form label association
3. `page.getByText('追加結果')` — visible text
4. `page.locator('#isbn')` — ID (stable if IDs are meaningful)
5. `page.locator('input[name="isbn"]')` — attribute
6. `page.locator('.result')` — class (fragile; use only for well-named utility classes)
7. `page.locator('table > tbody > tr:nth-child(2)')` — positional (last resort)

---

## Checklist Before Handing Off Tests

- [ ] `playwright.config.js` exists with correct `baseURL` and `testDir`
- [ ] Browser binaries installed (`playwright install chromium`)
- [ ] Server is running at `baseURL` before `playwright test`
- [ ] Each test is in its own `test()` block (not nested)
- [ ] `waitForNavigation` / `waitForURL` used around form submits that cause redirects
- [ ] `waitForSelector` or `networkidle` used for pages with async JS content
- [ ] No hardcoded `sleep()`/`setTimeout()` — use Playwright wait APIs instead
- [ ] Sensitive data (passwords, tokens) read from `process.env`, not hardcoded
- [ ] `--headed` tested manually at least once before committing

---

## References

- Playwright docs: https://playwright.dev/docs/intro
- Locator guide: https://playwright.dev/docs/locators
- Best practices: https://playwright.dev/docs/best-practices
- Network mocking: https://playwright.dev/docs/network (for mocking CGI responses in unit-style tests)
