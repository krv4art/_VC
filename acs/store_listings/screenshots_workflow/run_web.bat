@echo off
chcp 65001 >nul
setlocal

if "%1"=="" (
    echo Использование: run_web.bat [код_языка]
    echo.
    echo Примеры:
    echo   run_web.bat en    - Английский
    echo   run_web.bat ru    - Русский
    echo   run_web.bat uk    - Украинский
    echo   run_web.bat de    - Немецкий
    echo   run_web.bat fr    - Французский
    echo   run_web.bat es    - Испанский
    echo   run_web.bat it    - Итальянский
    echo.
    echo Доступные языки:
    echo   en, ru, uk, de, fr, es, it, pt, pl, ar, cs, da, el, fi, hi, hu, id, ja, ko, nl, no, ro, sv, th, tr, vi, zh
    exit /b 1
)

set LOCALE=%1

echo ========================================
echo Запуск ACS в браузере
echo Язык: %LOCALE%
echo ========================================
echo.
echo Приложение откроется в браузере через несколько секунд...
echo Для создания скриншотов:
echo   1. Нажмите F12 для открытия DevTools
echo   2. Включите Device Toolbar (Ctrl+Shift+M)
echo   3. Выберите устройство (например, iPhone 14 Pro Max)
echo   4. Делайте скриншоты через DevTools или расширение браузера
echo.
echo Для остановки нажмите Ctrl+C
echo ========================================
echo.

cd /d "%~dp0..\.."
flutter run -d chrome -t lib/screenshot_mode_main.dart --dart-define=LOCALE=%LOCALE%

endlocal
