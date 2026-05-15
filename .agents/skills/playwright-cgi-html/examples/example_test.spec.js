// @ts-check
const { test, expect } = require('@playwright/test');

// Example: CGI/HTML web application test
test.describe('Book Manager - Add page', () => {
  test('should render ISBN input and submit button', async ({ page }) => {
    await page.goto('http://localhost/html/add.html');
    await expect(page.locator('input#isbn')).toBeVisible();
    await expect(page.locator('input[type="submit"]')).toBeVisible();
  });

  test('form POST to CGI returns result page', async ({ page }) => {
    await page.goto('http://localhost/html/add.html');
    await page.fill('input#isbn', '9784873119076');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL(/add\.cgi/);
    await expect(page.locator('h1')).toContainText('書籍追加結果');
  });
});
