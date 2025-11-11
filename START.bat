@echo off
chcp 65001 >nul
cls

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║    GOOGLE PLAY CONSOLE UPLOADER - СТАРТОВЫЙ СКРИПТ         ║
echo ║            Автоматизация загрузки описаний                  ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

setlocal enabledelayedexpansion

:menu
cls
echo.
echo 📋 ВЫБЕРИТЕ ДЕЙСТВИЕ:
echo.
echo   1. 📊 Показать статистику (количество языков, символов)
echo   2. 👀 Показать предпросмотр для конкретного языка
echo   3. 📤 Экспортировать данные (JSON, CSV, скрипт для браузера)
echo   4. 📖 Открыть руководство (UPLOAD_GUIDE.md)
echo   5. 🌐 Открыть папку с файлами
echo   6. 🔄 Обновить и пересчитать данные
echo   7. ❌ Выход
echo.

set /p choice="Введите номер (1-7): "

if "%choice%"=="1" goto stats
if "%choice%"=="2" goto preview
if "%choice%"=="3" goto export
if "%choice%"=="4" goto guide
if "%choice%"=="5" goto folder
if "%choice%"=="6" goto refresh
if "%choice%"=="7" goto exit
goto menu

:stats
cls
echo.
node upload-manager.js --stats
pause
goto menu

:preview
cls
echo.
echo 🌍 ДОСТУПНЫЕ ЯЗЫКИ:
echo   en (English)    ru (Русский)    el (Ελληνικά)
echo   de (Deutsch)    fr (Français)   es (Español)
echo   ja (日本語)     zh-CN (简体中文)  zh-TW (繁體中文)
echo   pt-BR (Português Brasileiro)    pt-PT (Português)
echo   hi (हिन्दी)     th (ไทย)        vi (Tiếng Việt)
echo   И другие...
echo.
set /p lang="Введите код языка (например: en, ru, el): "

if "%lang%"=="" (
    echo ❌ Код языка не введен!
    timeout /t 2 >nul
    goto menu
)

echo.
node upload-manager.js --preview %lang%
pause
goto menu

:export
cls
echo.
echo 📤 ЭКСПОРТИРОВАНИЕ ДАННЫХ...
echo.
node upload-manager.js --export

echo.
echo ✅ Готово! Созданы файлы:
echo   • upload-data.json          (для просмотра)
echo   • upload-data.csv           (для Excel/Sheets)
echo   • browser-upload-script.js  (для Google Play Console)
echo.
echo 📝 Следующий шаг:
echo   1. Откройте browser-upload-script.js
echo   2. Скопируйте содержимое
echo   3. Вставьте в консоль Google Play Console (F12)
echo   4. Запустите команду в консоли браузера:
echo      await uploadLanguage('en');
echo      await uploadLanguage('ru');
echo      И т.д. для каждого языка
echo.
pause
goto menu

:guide
cls
start notepad UPLOAD_GUIDE.md
timeout /t 1 >nul
goto menu

:folder
cls
explorer "acs\store_listings\shared"
timeout /t 1 >nul
goto menu

:refresh
cls
echo.
echo 🔄 ПЕРЕСЧЕТ ДАННЫХ...
echo.
node upload-manager.js --all
pause
goto menu

:exit
cls
echo.
echo 👋 До свидания!
echo.
pause
exit /b 0
