@echo off
chcp 65001 >nul
setlocal

:menu
cls
echo ========================================
echo    ACS - Быстрый запуск для скриншотов
echo ========================================
echo.
echo Основные языки:
echo   1. English (en)
echo   2. Русский (ru)
echo   3. Українська (uk)
echo   4. Deutsch (de)
echo   5. Français (fr)
echo   6. Español (es)
echo   7. Italiano (it)
echo.
echo Дополнительные языки:
echo   8. Português (pt)
echo   9. Polski (pl)
echo  10. 中文 (zh)
echo  11. 日本語 (ja)
echo  12. 한국어 (ko)
echo  13. العربية (ar)
echo.
echo  0. Выход
echo.
echo ========================================
set /p choice="Выберите язык (0-13): "

if "%choice%"=="0" exit /b 0
if "%choice%"=="1" set LOCALE=en
if "%choice%"=="2" set LOCALE=ru
if "%choice%"=="3" set LOCALE=uk
if "%choice%"=="4" set LOCALE=de
if "%choice%"=="5" set LOCALE=fr
if "%choice%"=="6" set LOCALE=es
if "%choice%"=="7" set LOCALE=it
if "%choice%"=="8" set LOCALE=pt
if "%choice%"=="9" set LOCALE=pl
if "%choice%"=="10" set LOCALE=zh
if "%choice%"=="11" set LOCALE=ja
if "%choice%"=="12" set LOCALE=ko
if "%choice%"=="13" set LOCALE=ar

if defined LOCALE (
    call "%~dp0run_windows.bat" %LOCALE%
    goto menu
) else (
    echo Неверный выбор!
    timeout /t 2 >nul
    goto menu
)

endlocal
