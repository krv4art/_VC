/**
 * СКРИПТ ДЛЯ ЗАГРУЗКИ В GOOGLE PLAY CONSOLE
 *
 * Инструкция:
 * 1. Откройте Google Play Console и перейдите в редактирование приложения
 * 2. Откройте DevTools (F12)
 * 3. Перейдите на вкладку Console
 * 4. Скопируйте и вставьте этот код
 * 5. Выполните команду: startUpload()
 */

// Функция для ввода текста

async function switchLanguage(langCode) {
  console.log('🌍 Переключение на язык: ' + langCode);
  
  await new Promise(r => setTimeout(r, 500));
  
  const dropdown = document.querySelector('[aria-haspopup="listbox"]');
  if (!dropdown) {
    console.error('❌ Dropdown языков не найден');
    return false;
  }
  
  dropdown.click();
  await new Promise(r => setTimeout(r, 1500));
  
  const langMap = {
    'en': 'en-US',
    'ar': '– ar',
    'hu': 'hu-HU',
    'vi': 'Вьетнамский',
    'el': 'el-GR',
    'da': 'da-DK',
    'id': 'Индонезийский',
    'es-ES': 'Испанский (Испания)',
    'es-419': 'Латинская Америка',
    'es': 'Испанский (Испания)',  // Исправлено
    'it': 'it-IT',
    'zh-TW': 'традиционная',
    'zh-CN': 'упрощенная',
    'ko': 'ko-KR',
    'de': 'de-DE',
    'nl': 'nl-NL',
    'no': 'no-NO',
    'pl': 'pl-PL',
    'pt-BR': 'Бразилия',
    'pt-PT': 'Португальский (Португалия)',  // Исправлено
    'ro': '– ro',  // Исправлено
    'ru': 'Русский',
    'th': 'Тайский',
    'tr': 'tr-TR',
    'fi': 'fi-FI',
    'fr': 'fr-FR',
    'hi': 'hi-IN',
    'cs': 'cs-CZ',
    'sv': 'sv-SE',
    'uk': 'Украинский',
    'ja': 'ja-JP'
  };
  
  const searchKey = langMap[langCode];
  if (!searchKey) {
    console.error('❌ Языка нет в маппинге: ' + langCode);
    return false;
  }
  
  console.log('🔍 Ищу по ключу: ' + searchKey);
  await new Promise(r => setTimeout(r, 800));
  
  const options = document.querySelectorAll('[role="option"]');
  console.log('📋 Найдено опций: ' + options.length);
  
  if (options.length === 0) {
    console.error('❌ Меню не открылось!');
    return false;
  }
  
  for (const option of options) {
    const optionText = option.innerText || option.textContent;
    
    if (optionText && optionText.includes(searchKey)) {
      console.log('✓ НАЙДЕН: ' + optionText.trim());
      option.click();
      await new Promise(r => setTimeout(r, 2000));
      console.log('✅ Переключен на: ' + langCode);
      return true;
    }
  }
  
  console.error('❌ Не найден язык с ключом: ' + searchKey);
  return false;
}

async function pasteText(element, text) {
  element.click();
  element.focus();
  element.value = '';
  element.dispatchEvent(new Event('input', { bubbles: true }));
  
  element.value = text;
  
  element.dispatchEvent(new Event('input', { bubbles: true }));
  element.dispatchEvent(new Event('change', { bubbles: true }));
  element.dispatchEvent(new Event('keydown', { bubbles: true }));
  element.dispatchEvent(new Event('keyup', { bubbles: true }));
  element.dispatchEvent(new Event('blur', { bubbles: true }));
  
  const parentLabel = element.closest('.mdc-text-field');
  if (parentLabel) {
    parentLabel.classList.add('mdc-text-field--filled');
  }
  
  const resizer = element.closest('.mdc-text-field__resizer');
  if (resizer) {
    resizer.style.height = 'auto';
    resizer.style.height = (element.scrollHeight + 10) + 'px';
  }
  
  await new Promise(r => setTimeout(r, 500));
}

function findFieldByAriaLabel(labelText) {
  return document.querySelector(`input[aria-label*="${labelText}"], textarea[aria-label*="${labelText}"]`);
}

async function uploadLanguage(lang) {
  console.log('\n🚀 Загрузка: ' + lang);
  
  const switched = await switchLanguage(lang);
  if (!switched) {
    console.error('⚠️ Пропускаю язык: ' + lang);
    return;
  }
  
  const data = uploadData[lang];
  if (!data) {
    console.error('❌ Нет данных: ' + lang);
    return;
  }

  const fields = {
    'App name': 'Название приложения',
    'Short description': 'Короткое описание приложения',
    'Full description': 'Полное описание приложения'
  };

  for (const [key, ariaLabel] of Object.entries(fields)) {
    const content = data[key];
    if (!content) continue;

    let field;
    if (key === 'App name') {
      field = document.querySelector('input[aria-label="Название приложения"]');
    } else {
      field = findFieldByAriaLabel(ariaLabel);
    }
    
    if (!field) {
      console.warn('⚠️ Поле не найдено: ' + key);
      continue;
    }
    
    console.log('  📝 ' + key);
    await pasteText(field, content);
  }

  console.log('✅ ' + lang + ' готов');
}

async function uploadAllLanguages(languages) {
  console.log('═'.repeat(50));
  console.log('🚀 ЗАГРУЗКА НАЧАТА');
  console.log('Языков: ' + languages.length);
  console.log('═'.repeat(50));
  
  for (const lang of languages) {
    await uploadLanguage(lang);
    await new Promise(r => setTimeout(r, 3500));
  }
  
  console.log('\n' + '═'.repeat(50));
  console.log('🎉 ВСЕ ЯЗЫКИ ЗАГРУЖЕНЫ!');
  console.log('═'.repeat(50));
  console.log('\n💾 НЕ ЗАБУДЬТЕ НАЖАТЬ SAVE!');
}

// после этого нужно выполнить команду по типу await uploadAllLanguages(['es', 'fi', 'pt-PT', 'ro']); в которой указаны все языки для заполнения
