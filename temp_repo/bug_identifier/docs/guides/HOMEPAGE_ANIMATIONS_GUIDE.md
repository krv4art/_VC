# Руководство по анимациям главного экрана

## Обзор

На главном экране приложения реализованы каскадные анимации появления элементов, которые создают плавный и привлекательный пользовательский опыт в соответствии с современными трендами дизайна мобильных приложений 2025 года.

## Архитектура анимаций

### Контроллеры анимации

В `_HomepageScreenState` используется три основных контроллера анимации:

1. **`_mainButtonController`** (800ms) - управляет анимацией главной кнопки сканирования
2. **`_quickActionsController`** (1000ms) - управляет анимацией блока быстрых действий
3. **`_settingsController`** (1200ms) - управляет анимацией блока настроек

### Типы анимаций

#### 1. Главная кнопка сканирования
- **Масштабирование**: от 0.8 до 1.0
- **Сдвиг**: от Offset(0, 0.3) до Offset.zero
- **Длительность**: 800ms
- **Кривая**: Curves.easeOutCubic
- **Задержка запуска**: 100ms

#### 2. Блок быстрых действий
- **Заголовок**: Fade-in с прозрачности 0.0 до 1.0
- **Карточки**: Каскадное появление с задержкой 60мс между элементами
- **Эффект**: FadeTransition + SlideTransition
- **Направление сдвига**: от Offset(0.2, 0) до Offset.zero
- **Длительность**: 1000ms
- **Задержка запуска**: 400ms

#### 3. Блок настроек
- **Заголовок**: Fade-in с прозрачности 0.0 до 1.0
- **Элементы списка**: Каскадное появление с задержкой 60мс между элементами
- **Эффект**: FadeTransition + SlideTransition
- **Направление сдвига**: от Offset(-0.2, 0) до Offset.zero
- **Длительность**: 1200ms
- **Задержка запуска**: 700ms

## Реализация

### Инициализация анимаций

```dart
void _initializeAnimations() {
  // Создание контроллеров с разными длительностями
  _mainButtonController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  
  // Настройка анимаций с использованием Curves.easeOutCubic
  _mainButtonScaleAnimation = Tween<double>(
    begin: 0.8,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _mainButtonController,
    curve: Curves.easeOutCubic,
  ));
}
```

### Запуск анимаций

```dart
void _startAnimations() {
  // Последовательный запуск с задержками между секциями
  Future.delayed(const Duration(milliseconds: 100), () {
    if (mounted) _mainButtonController.forward();
  });
  
  Future.delayed(const Duration(milliseconds: 400), () {
    if (mounted) _quickActionsController.forward();
  });
  
  Future.delayed(const Duration(milliseconds: 700), () {
    if (mounted) _settingsController.forward();
  });
}
```

### Применение анимаций к виджетам

```dart
AnimatedBuilder(
  animation: _mainButtonController,
  builder: (context, child) {
    return Transform.scale(
      scale: _mainButtonScaleAnimation.value,
      child: SlideTransition(
        position: _mainButtonSlideAnimation,
        child: // Ваш виджет
      ),
    );
  },
)
```

## Параметры анимации

### Интервалы для каскадных эффектов

- **Быстрые действия**: 60мс между карточками
  - Карточка 1: Interval(0.1, 0.6)
  - Карточка 2: Interval(0.16, 0.66)
  - Карточка 3: Interval(0.22, 0.72)

- **Настройки**: 60мс между элементами списка
  - Элемент 1: Interval(0.1, 0.4)
  - Элемент 2: Interval(0.16, 0.46)
  - Элемент 3: Interval(0.22, 0.52)
  - Элемент 4: Interval(0.28, 0.58)

### Кривые анимации

Используется `Curves.easeOutCubic` для создания плавных, органичных движений, которые соответствуют современным трендам дизайна.

## Соответствие трендам 2025 года

Реализованные анимации соответствуют следующим трендам:

1. **Каскадные анимации** - элементы появляются последовательно с задержкой 60мс
2. **Микро-взаимодействия** - плавные переходы 300-1200ms
3. **Органичные движения** - использование Curves.easeOutCubic вместо резких переходов
4. **Адаптивность** - анимации автоматически подстраиваются под тему приложения
5. **Производительность** - оптимизированы для 60 FPS

## Технические рекомендации

### Производительность

- Все анимации используют `TickerProviderStateMixin` для оптимальной производительности
- Контроллеры правильно dispose в методе `dispose()`
- Проверка `mounted` перед запуском анимаций

### Доступность

- Анимации имеют умеренную длительность (800-1200ms)
- Используются стандартные кривые анимации Flutter
- Поддерживается системная настройка `prefers-reduced-motion`

### Кастомизация

Для изменения параметров анимации:

1. **Длительность**: измените значения в `AnimationController`
2. **Задержки**: измените значения в `Future.delayed()`
3. **Интервалы**: измените значения в `Interval()`
4. **Кривые**: замените `Curves.easeOutCubic` на другую кривую

## Пример добавления новой анимации

```dart
// 1. Добавьте контроллер
late AnimationController _newSectionController;

// 2. Добавьте анимацию
late Animation<double> _newSectionAnimation;

// 3. Инициализируйте в _initializeAnimations()
_newSectionController = AnimationController(
  duration: const Duration(milliseconds: 800),
  vsync: this,
);

_newSectionAnimation = Tween<double>(
  begin: 0.0,
  end: 1.0,
).animate(CurvedAnimation(
  parent: _newSectionController,
  curve: Curves.easeOutCubic,
));

// 4. Запустите в _startAnimations()
Future.delayed(const Duration(milliseconds: 1000), () {
  if (mounted) _newSectionController.forward();
});

// 5. Примените к виджету
AnimatedBuilder(
  animation: _newSectionController,
  builder: (context, child) {
    return FadeTransition(
      opacity: _newSectionAnimation,
      child: // Ваш виджет
    );
  },
)

// 6. Не забудьте dispose
@override
void dispose() {
  _newSectionController.dispose();
  super.dispose();
}
```

## Заключение

Реализованные каскадные анимации создают современный, плавный и привлекательный пользовательский интерфейс, который соответствует последним трендам дизайна мобильных приложений. Анимации оптимизированы для производительности и доступны для всех пользователей.