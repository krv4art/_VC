# Настройка Windows для создания скриншотов

## Установка Visual Studio

Для запуска Flutter приложений на Windows нужен Visual Studio с компонентами C++.

### Шаг 1: Скачать Visual Studio

**Вариант A: Visual Studio 2022 Community (РЕКОМЕНДУЕТСЯ - бесплатная)**
- Скачайте с: https://visualstudio.microsoft.com/downloads/
- Выберите **Community** (бесплатная версия)

**Вариант B: Build Tools for Visual Studio 2022 (минимальная установка)**
- Скачайте с: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
- Более лёгкий вариант, только инструменты сборки

### Шаг 2: Установка компонентов

При установке Visual Studio обязательно выберите:

✅ **Desktop development with C++** (Разработка классических приложений на C++)

Это основной компонент! Он включает:
- MSVC v143 - VS 2022 C++ x64/x86 build tools
- Windows 10/11 SDK
- C++ CMake tools for Windows

### Шаг 3: Проверка установки

После установки откройте терминал и выполните:

```bash
flutter doctor
```

Вы должны увидеть:
```
[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.x.x)
```

### Шаг 4: Если что-то не так

Если Flutter не видит Visual Studio:

1. Перезапустите компьютер
2. Убедитесь что установлен компонент "Desktop development with C++"
3. Попробуйте переустановить Visual Studio

## Альтернатива: Использовать браузер

Если не хотите устанавливать Visual Studio (это ~6-8 GB):
- См. **[BROWSER_SCREENSHOTS.md](BROWSER_SCREENSHOTS.md)** - инструкция для создания скриншотов в браузере
- Браузерный вариант работает БЕЗ Visual Studio!

## Время установки

- **Скачивание:** ~15-30 минут (зависит от интернета)
- **Установка:** ~10-20 минут
- **Итого:** ~30-60 минут

## Размер

- **Visual Studio Community:** ~6-8 GB
- **Build Tools только:** ~3-4 GB

## После установки

Запустите приложение:
```bash
cd acs
store_listings\screenshots_workflow\run_windows.bat ru
```

Теперь скриншоты будут сохраняться автоматически при нажатии F9!
