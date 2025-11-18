@echo off
chcp 65001 >nul
setlocal

if "%1"=="" (
    echo Использование: run_windows.bat [код_языка]
    echo.
    echo Примеры:
    echo   run_windows.bat en    - Английский
    echo   run_windows.bat ru    - Русский
    echo   run_windows.bat uk    - Украинский
    echo   run_windows.bat de    - Немецкий
    echo   run_windows.bat fr    - Французский
    echo   run_windows.bat es    - Испанский
    echo   run_windows.bat it    - Итальянский
    echo.
    echo Доступные языки:
    echo   en, ru, uk, de, fr, es, it, pt, pl, ar, cs, da, el, fi, hi, hu, id, ja, ko, nl, no, ro, sv, th, tr, vi, zh
    exit /b 1
)

set LOCALE=%1

echo ========================================
echo Запуск ACS для Windows
echo Язык: %LOCALE%
echo ========================================
echo.
echo Приложение запускается...
echo.
echo Для создания скриншотов:
echo   1. Установите размер окна под нужное устройство
echo   2. Используйте Win+Shift+S для скриншота области
echo   3. Или используйте инструмент Snipping Tool
echo   4. Сохраняйте в папку: store_listings\screenshots\%LOCALE%\
echo.
echo Рекомендуемые размеры для разных устройств:
echo   iPhone 14 Pro Max: 430x932 (логические пиксели)
echo   Google Pixel 7 Pro: 412x915 (логические пиксели)
echo.
echo Для остановки закройте приложение
echo ========================================
echo.

cd /d "%~dp0..\.."
flutter run -d windows -t lib/screenshot_mode_main.dart --dart-define=LOCALE=%LOCALE%

endlocal
