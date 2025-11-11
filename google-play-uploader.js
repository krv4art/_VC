const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Конфигурация
const CONFIG = {
  storePath: path.join(__dirname, 'acs', 'store_listings', 'shared'),
  headless: false, // Показать браузер для контроля
  slowMo: 100, // Замедление между действиями
  timeout: 30000,
  // Языки для загрузки (оставьте null для всех языков)
  languages: null, // или ['en', 'ru', 'el', 'ja']
};

// Маппинг полей Google Play Console
const FIELD_MAPPING = {
  name: {
    file: 'name.txt',
    selector: '[data-field-id="title"]', // Может отличаться
    maxLength: 50,
  },
  shortDescription: {
    file: 'short_description_google_play.txt',
    selector: '[data-field-id="short_description"]',
    maxLength: 80,
  },
  description: {
    file: 'description.txt',
    selector: '[data-field-id="full_description"]',
    maxLength: 4000,
  },
  keywords: {
    file: 'keywords.txt',
    selector: '[data-field-id="keywords"]',
    maxLength: 100,
  },
  promoText: {
    file: 'promo_text_google_play.txt',
    selector: '[data-field-id="promotional_text"]',
    maxLength: 80,
  },
};

// Функция для чтения файла с кодировкой UTF-8
function readFile(filePath) {
  try {
    return fs.readFileSync(filePath, 'utf-8').trim();
  } catch (error) {
    console.error(`Ошибка при чтении файла ${filePath}:`, error.message);
    return null;
  }
}

// Функция для получения всех доступных языков
function getAvailableLanguages() {
  const langDir = CONFIG.storePath;
  if (!fs.existsSync(langDir)) {
    throw new Error(`Папка со языками не найдена: ${langDir}`);
  }

  const languages = fs
    .readdirSync(langDir)
    .filter(file => fs.statSync(path.join(langDir, file)).isDirectory())
    .sort();

  return languages;
}

// Функция для загрузки данных языка
function loadLanguageData(lang) {
  const langPath = path.join(CONFIG.storePath, lang);
  const data = {};

  for (const [fieldKey, fieldConfig] of Object.entries(FIELD_MAPPING)) {
    const filePath = path.join(langPath, fieldConfig.file);
    const content = readFile(filePath);
    if (content) {
      data[fieldKey] = content;
    }
  }

  return data;
}

// Основная функция для заполнения полей
async function fillLanguageData(page, lang, data) {
  console.log(`\n📝 Заполнение полей для языка: ${lang}`);

  for (const [fieldKey, content] of Object.entries(data)) {
    const fieldConfig = FIELD_MAPPING[fieldKey];
    console.log(`  - ${fieldKey}: ${content.substring(0, 50)}...`);

    // Ищем поле по селектору
    try {
      const selector = fieldConfig.selector;
      await page.waitForSelector(selector, { timeout: 5000 });

      // Очищаем поле
      await page.click(selector);
      await page.keyboard.press('Control+A');
      await page.keyboard.press('Delete');

      // Вводим новое значение
      await page.type(selector, content, { delay: 10 });

      console.log(`    ✓ Заполнено`);
    } catch (error) {
      console.warn(`    ✗ Не удалось заполнить поле ${fieldKey}: ${error.message}`);
    }

    await page.waitForTimeout(500);
  }
}

// Функция для переключения языка в Google Play Console
async function switchLanguage(page, lang) {
  console.log(`\n🌍 Переключение на язык: ${lang}`);

  try {
    // Нажимаем на dropdown со языками (селектор может отличаться)
    const languageButton = await page.$('[data-language-selector]');

    if (!languageButton) {
      console.warn('⚠️ Не найден переключатель языков. Вы можете переключиться вручную.');
      // Останавливаем скрипт для ручного переключения
      await page.waitForTimeout(10000);
      return true;
    }

    await languageButton.click();
    await page.waitForTimeout(500);

    // Ищем опцию для нужного языка
    const languageOption = await page.$(`[data-language-code="${lang}"]`);
    if (languageOption) {
      await languageOption.click();
      await page.waitForTimeout(2000);
      return true;
    }
  } catch (error) {
    console.error(`Ошибка при переключении языка: ${error.message}`);
  }

  return false;
}

// Основная функция
async function main() {
  let browser;

  try {
    console.log('🚀 Запуск Google Play Console Uploader\n');

    // Получаем доступные языки
    let languages = getAvailableLanguages();

    if (CONFIG.languages) {
      languages = languages.filter(lang => CONFIG.languages.includes(lang));
    }

    console.log(`📂 Найдено языков: ${languages.length}`);
    console.log(`   ${languages.join(', ')}\n`);

    // Запускаем браузер
    browser = await puppeteer.launch({
      headless: CONFIG.headless,
      args: ['--start-maximized'],
    });

    const page = await browser.newPage();
    await page.setDefaultTimeout(CONFIG.timeout);
    await page.setDefaultNavigationTimeout(CONFIG.timeout);

    // Открываем Google Play Console
    console.log('🌐 Открытие Google Play Console...');
    await page.goto('https://play.google.com/console', { waitUntil: 'networkidle2' });

    // Ждем, когда пользователь войдет и выберет приложение
    console.log('\n⏳ Пожалуйста, войдите в Google Play Console и откройте приложение.');
    console.log('   После этого нажмите любую клавишу в консоли для продолжения.\n');

    // Ждем 5 минут для входа
    let userReady = false;
    const waitPromise = new Promise(resolve => {
      const timer = setTimeout(() => {
        console.log('Таймаут ввода. Продолжаю с текущей страницы...');
        resolve();
      }, 300000); // 5 минут

      process.stdin.once('data', () => {
        clearTimeout(timer);
        resolve();
      });
    });

    await waitPromise;

    // Проходим по каждому языку
    for (const lang of languages) {
      const data = loadLanguageData(lang);

      if (Object.keys(data).length === 0) {
        console.log(`⚠️ Нет данных для языка ${lang}, пропускаем.`);
        continue;
      }

      // Переключаемся на язык
      await switchLanguage(page, lang);

      // Заполняем поля
      await fillLanguageData(page, lang, data);

      // Сохраняем (нажимаем кнопку сохранения)
      console.log(`\n💾 Сохранение данных для ${lang}...`);
      try {
        const saveButton = await page.$('button[aria-label*="Save"], button:has-text("Save")');
        if (saveButton) {
          await saveButton.click();
          await page.waitForTimeout(2000);
          console.log('✅ Данные сохранены');
        } else {
          console.warn('⚠️ Не найдена кнопка сохранения. Может потребоваться ручное сохранение.');
        }
      } catch (error) {
        console.warn(`⚠️ Ошибка при сохранении: ${error.message}`);
      }

      await page.waitForTimeout(1000);
    }

    console.log('\n✨ Загрузка завершена!');
    console.log('💡 Браузер остается открытым. Проверьте данные и закройте вручную.');

    // Держим браузер открытым для проверки
    await new Promise(() => {});

  } catch (error) {
    console.error('❌ Критическая ошибка:', error);
    process.exit(1);
  } finally {
    // Закрытие браузера (никогда не выполнится в этом скрипте)
    if (browser) {
      await browser.close();
    }
  }
}

// Запуск
main().catch(console.error);
