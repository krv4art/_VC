#!/usr/bin/env node

/**
 * МЕНЕДЖЕР ЗАГРУЗКИ В GOOGLE PLAY CONSOLE
 *
 * Использование:
 * node upload-manager.js [опции]
 *
 * Опции:
 *   --lang <lang>     Загрузить конкретный язык (en, ru, el и т.д.)
 *   --all             Загрузить все языки
 *   --export          Экспортировать данные в JSON
 *   --dry-run         Показать что будет загружено (без реальной загрузки)
 */

const fs = require('fs');
const path = require('path');

// ==================== КОНФИГУРАЦИЯ ====================
const CONFIG = {
  storePath: path.join(__dirname, 'acs', 'store_listings', 'shared'),
  outputPath: path.join(__dirname, 'upload-data.json'),
};

// ==================== ФАЙЛЫ И ПОЛЯ ====================
const FILES_STRUCTURE = {
  name: {
    file: 'name.txt',
    label: 'App name',
    maxLength: 50,
  },
  shortDescription: {
    file: 'short_description_google_play.txt',
    label: 'Short description',
    maxLength: 80,
  },
  description: {
    file: 'description.txt',
    label: 'Full description',
    maxLength: 4000,
  },
  keywords: {
    file: 'keywords.txt',
    label: 'Keywords',
    maxLength: 100,
  },
  promoText: {
    file: 'promo_text_google_play.txt',
    label: 'Promotional text',
    maxLength: 80,
  },
};

// ==================== УТИЛИТЫ ====================

function log(message, type = 'info') {
  const icons = {
    info: '💡',
    success: '✅',
    warning: '⚠️',
    error: '❌',
    arrow: '→',
    loading: '⏳',
  };

  const prefix = icons[type] || '';
  console.log(`${prefix} ${message}`);
}

function readFile(filePath) {
  try {
    return fs.readFileSync(filePath, 'utf-8').trim();
  } catch (error) {
    return null;
  }
}

function getAvailableLanguages() {
  const langDir = CONFIG.storePath;

  if (!fs.existsSync(langDir)) {
    log(`Папка не найдена: ${langDir}`, 'error');
    process.exit(1);
  }

  return fs
    .readdirSync(langDir)
    .filter(file => fs.statSync(path.join(langDir, file)).isDirectory())
    .sort();
}

// ==================== ЗАГРУЗКА ДАННЫХ ====================

function loadLanguageData(lang) {
  const langPath = path.join(CONFIG.storePath, lang);
  const data = {};

  for (const [fieldKey, fieldConfig] of Object.entries(FILES_STRUCTURE)) {
    const filePath = path.join(langPath, fieldConfig.file);
    const content = readFile(filePath);

    if (content) {
      // Проверяем длину
      if (content.length > fieldConfig.maxLength) {
        log(
          `Внимание: ${lang}/${fieldKey} длиннее чем ${fieldConfig.maxLength} символов (${content.length})`,
          'warning'
        );
      }

      data[fieldKey] = {
        label: fieldConfig.label,
        content: content,
        file: fieldConfig.file,
        length: content.length,
        maxLength: fieldConfig.maxLength,
      };
    }
  }

  return data;
}

function loadAllLanguages() {
  const languages = getAvailableLanguages();
  const allData = {};

  for (const lang of languages) {
    const data = loadLanguageData(lang);
    if (Object.keys(data).length > 0) {
      allData[lang] = data;
    }
  }

  return allData;
}

// ==================== ЭКСПОРТ ====================

function exportToJSON(allData) {
  const output = {};

  for (const [lang, data] of Object.entries(allData)) {
    output[lang] = {};
    for (const [fieldKey, fieldData] of Object.entries(data)) {
      output[lang][fieldKey] = fieldData.content;
    }
  }

  const jsonPath = CONFIG.outputPath;
  fs.writeFileSync(jsonPath, JSON.stringify(output, null, 2), 'utf-8');
  log(`Данные экспортированы: ${jsonPath}`, 'success');
}

function exportToCSV(allData) {
  const languages = Object.keys(allData);
  const fields = Object.keys(FILES_STRUCTURE);

  let csv = 'Language,' + fields.join(',') + '\n';

  for (const lang of languages) {
    const row = [lang];
    for (const field of fields) {
      const content = allData[lang][field]?.content || '';
      // Экранируем кавычки в CSV
      const escaped = `"${content.replace(/"/g, '""')}"`;
      row.push(escaped);
    }
    csv += row.join(',') + '\n';
  }

  const csvPath = CONFIG.outputPath.replace('.json', '.csv');
  fs.writeFileSync(csvPath, csv, 'utf-8');
  log(`CSV экспортирован: ${csvPath}`, 'success');
}

// ==================== DISPLAY ====================

function displayStats(allData) {
  console.log('\n' + '='.repeat(60));
  console.log('📊 СТАТИСТИКА');
  console.log('='.repeat(60));

  let totalChars = 0;
  let langCount = 0;

  for (const [lang, data] of Object.entries(allData)) {
    langCount++;
    let langChars = 0;

    for (const [fieldKey, fieldData] of Object.entries(data)) {
      langChars += fieldData.length;
    }

    totalChars += langChars;
    console.log(`  ${lang.padEnd(10)} - ${Object.keys(data).length} полей, ${langChars} символов`);
  }

  console.log('='.repeat(60));
  console.log(`✓ Всего языков: ${langCount}`);
  console.log(`✓ Всего символов: ${totalChars.toLocaleString('ru-RU')}`);
  console.log('='.repeat(60) + '\n');
}

function displayPreview(allData, lang = null) {
  const languagesToShow = lang ? [lang] : Object.keys(allData).slice(0, 2);

  console.log('\n' + '='.repeat(60));
  console.log('👀 ПРЕДПРОСМОТР ДАННЫХ');
  console.log('='.repeat(60));

  for (const language of languagesToShow) {
    if (!allData[language]) continue;

    console.log(`\n🌍 ${language.toUpperCase()}`);
    console.log('-'.repeat(60));

    const data = allData[language];

    for (const [fieldKey, fieldData] of Object.entries(data)) {
      const content = fieldData.content;
      const preview = content.substring(0, 60).replace(/\n/g, ' ') + (content.length > 60 ? '...' : '');
      console.log(`  ${fieldKey.padEnd(20)} | ${preview}`);
      console.log(`  ${''.padEnd(20)} | ↳ ${fieldData.length}/${fieldData.maxLength} символов`);
    }
  }

  console.log('\n' + '='.repeat(60) + '\n');
}

// ==================== ГЕНЕРАЦИЯ СКРИПТА ДЛЯ БРАУЗЕРА ====================

function generateBrowserScript(allData) {
  const languages = Object.keys(allData);
  const scriptContent = `
// АВТОМАТИЧЕСКИ СГЕНЕРИРОВАННЫЙ СКРИПТ
// Скопируйте и запустите в консоли Google Play Console

const uploadData = {
${languages
  .map(
    lang =>
      `  "${lang}": {
${Object.entries(allData[lang])
  .map(
    ([fieldKey, fieldData]) =>
      `    "${fieldData.label}": ${JSON.stringify(fieldData.content)}`
  )
  .join(',\n')}
  }`
  )
  .join(',\n')}
};

// Функция для ввода текста
async function typeText(element, text, delay = 50) {
  element.click();
  element.value = '';
  for (const char of text) {
    element.value += char;
    element.dispatchEvent(new Event('input', { bubbles: true }));
    element.dispatchEvent(new Event('change', { bubbles: true }));
    await new Promise(resolve => setTimeout(resolve, delay));
  }
}

// Функция для поиска поля по лейблу
function findFieldByLabel(labelText) {
  const labels = document.querySelectorAll('label, [role="label"], .label-text, span');
  for (const label of labels) {
    if (label.textContent.trim() === labelText || label.textContent.includes(labelText)) {
      const parent = label.closest('.field, .input-group, [data-field], div');
      if (parent) {
        const input = parent.querySelector('input, textarea');
        if (input) return input;
      }
    }
  }
  return null;
}

// Главная функция загрузки
async function uploadLanguage(lang) {
  console.log('🚀 Загрузка для языка: ' + lang);
  const data = uploadData[lang];

  for (const [label, content] of Object.entries(data)) {
    const field = findFieldByLabel(label);
    if (!field) {
      console.warn('❌ Поле не найдено: ' + label);
      continue;
    }
    console.log('📝 Заполняю: ' + label);
    await typeText(field, content);
    await new Promise(r => setTimeout(r, 500));
  }

  console.log('✅ Язык ' + lang + ' загружен');
}

// Запуск: await uploadLanguage('en');
console.log('✨ Скрипт загружен! Используйте: await uploadLanguage("en")');
console.log('📋 Доступные языки:', Object.keys(uploadData));
`;

  const scriptPath = path.join(path.dirname(CONFIG.outputPath), 'browser-upload-script.js');
  fs.writeFileSync(scriptPath, scriptContent, 'utf-8');
  log(`Скрипт для браузера создан: ${scriptPath}`, 'success');
}

// ==================== MAIN ====================

function main() {
  const args = process.argv.slice(2);

  console.log('\n' + '='.repeat(60));
  console.log('🚀 GOOGLE PLAY CONSOLE UPLOAD MANAGER');
  console.log('='.repeat(60) + '\n');

  // Загружаем все данные
  const allData = loadAllLanguages();

  if (Object.keys(allData).length === 0) {
    log('Не найдены данные для загрузки!', 'error');
    process.exit(1);
  }

  // Обработка аргументов
  if (args.includes('--export')) {
    log('Экспорт данных...', 'loading');
    exportToJSON(allData);
    exportToCSV(allData);
    generateBrowserScript(allData);
  }

  if (args.includes('--stats') || args.includes('--all')) {
    displayStats(allData);
  }

  if (args.includes('--preview')) {
    const langIndex = args.indexOf('--preview');
    const lang = args[langIndex + 1];
    displayPreview(allData, lang);
  } else if (!args.length) {
    // Показываем справку
    displayStats(allData);
    displayPreview(allData);
  }

  // Опция --dry-run
  if (args.includes('--dry-run')) {
    log('DRY RUN: следующие данные будут загружены:', 'info');
    for (const lang of Object.keys(allData)) {
      console.log(`  • ${lang}`);
    }
  }

  console.log('\n📖 Использование:');
  console.log('  node upload-manager.js --export     Экспортировать данные в JSON/CSV');
  console.log('  node upload-manager.js --preview en Показать предпросмотр для языка');
  console.log('  node upload-manager.js --stats      Показать статистику');
  console.log('  node upload-manager.js --all        Показать всё\n');
}

main();
