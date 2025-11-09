# Система анимаций приложения ACS

## Обзор

Система анимаций ACS - это комплексный подход к созданию плавных, современных и производительных анимаций во всем приложении. Документация охватывает принципы, паттерны и реализации для всех экранов приложения.

## Философия анимаций

### Основные принципы

1. **Органичность** - анимации должны mimic естественные движения
2. **Последовательность** - элементы появляются логично и предсказуемо
3. **Производительность** - все анимации оптимизированы для 60 FPS
4. **Доступность** - уважение к настройкам предпочтений пользователей
5. **Согласованность** - единый язык анимаций во всем приложении

### Тренды 2025 года

- Каскадные анимации с задержкой 60мс
- Микро-взаимодействия 300-1200ms
- Адаптивные анимации, реагирующие на поведение пользователя
- Плавные переходы Curves.easeOutCubic
- Тематические анимации, адаптирующиеся под цветовую схему

## Архитектура системы анимаций

### Базовые компоненты

```
lib/
├── animations/
│   ├── animations_manager.dart      # Управление анимациями
│   ├── staggered_animation.dart     # Каскадные анимации
│   ├── page_transition.dart         # Переходы между экранами
│   └── micro_interactions.dart      # Микро-взаимодействия
├── widgets/
│   ├── animated/
│   │   ├── animated_card.dart       # Анимированная карточка
│   │   ├── animated_button.dart     # Анимированная кнопка
│   │   └── animated_list_item.dart  # Анимированный элемент списка
│   └── transitions/
│       ├── slide_transition.dart    # Слайд-переходы
│       └── fade_transition.dart     # Fade-переходы
```

### Типы анимаций

#### 1. Входные анимации (Entrance Animations)
- **Каскадное появление** - элементы появляются последовательно
- **Появление из ниоткуда** - fade-in + scale/translate
- **Выезд из-за границ** - slide-in от краев экрана

#### 2. Переходные анимации (Transition Animations)
- **Межэкранные переходы** - smooth transitions между экранами
- **Состояния элементов** - анимации изменения состояний
- **Микро-взаимодействия** - отклик на действия пользователя

#### 3. Фоновые анимации (Background Animations)
- **Загрузочные индикаторы** - анимированные лоадеры
- **Ambient animations** - фоновые движения для атмосферы
- **Status animations** - индикаторы состояний

## Реализованные анимации по экранам

### 1. Главный экран (HomepageScreen)

**Контроллеры:**
- `_mainButtonController` (800ms) - главная кнопка сканирования
- `_quickActionsController` (1000ms) - блок быстрых действий
- `_settingsController` (1200ms) - блок настроек

**Эффекты:**
- Масштабирование + сдвиг для главной кнопки
- Каскадное появление карточек (60мс задержка)
- Fade-in + slide для заголовков

### 2. Экран сканирования (ScanningScreen)

**Анимации:**
- Дыхание рамки сканирования
- Появление UI элементов с задержкой
- Индикатор фокусировки
- Анимация обработки сканирования

### 3. Экран результатов (AnalysisResultsScreen)

**Планируемые анимации:**
- Появление карточки оценки
- Каскадное раскрытие секций ингредиентов
- Анимация кнопок действий
- Плавное появление рекомендаций

### 4. Профиль (ProfileScreen)

**Планируемые анимации:**
- Анимация аватара при загрузке
- Появление секций профиля
- Анимация переключателей настроек

### 5. Диалоги (RatingRequestDialog)

**Реализованные анимации:**
- Плавное появление диалога
- Анимация переключения шагов
- Анимация звезд рейтинга
- Появление полей ввода

## Универсальные паттерны анимаций

### 1. Каскадное появление списка

```dart
class StaggeredListAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration duration;
  final Offset slideDirection;

  const StaggeredListAnimation({
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 300),
    this.slideDirection = const Offset(0.2, 0),
  });

  @override
  _StaggeredListAnimationState createState() => _StaggeredListAnimationState();
}

class _StaggeredListAnimationState extends State<StaggeredListAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    
    _animations = List.generate(widget.children.length, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * widget.staggerDelay.inMilliseconds / widget.duration.inMilliseconds,
            (index + 1) * widget.staggerDelay.inMilliseconds / widget.duration.inMilliseconds,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.asMap().entries.map((entry) {
        return AnimatedBuilder(
          animation: _animations[entry.key],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[entry.key],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: widget.slideDirection,
                  end: Offset.zero,
                ).animate(_animations[entry.key]),
                child: entry.value,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
```

### 2. Анимированная карточка

```dart
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleAmount;

  const AnimatedCard({
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
    this.scaleAmount = 0.95,
  });

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
```

### 3. Плавное появление страницы

```dart
class PageEntranceAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const PageEntranceAnimation({
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  _PageEntranceAnimationState createState() => _PageEntranceAnimationState();
}

class _PageEntranceAnimationState extends State<PageEntranceAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
```

## Стандартные параметры анимаций

### Длительности
- **Микро-взаимодействия**: 150-300ms
- **Элементы интерфейса**: 300-500ms
- **Секционные анимации**: 500-800ms
- **Страничные переходы**: 800-1200ms

### Задержки каскада
- **Стандартная**: 60ms между элементами
- **Быстрая**: 30ms между элементами
- **Медленная**: 100ms между элементами

### Кривые анимации
- **EaseOutCubic**: стандартная для появления
- **EaseInOut**: для циклических анимаций
- **EaseOutBack**: для эффектов упругости
- **EaseOutElastic**: для специальных эффектов

## Интеграция с темами

### Адаптивные цвета

Все анимации автоматически адаптируются под текущую тему:

```dart
// Использование тематических цветов в анимациях
Color get animationColor => context.colors.primary;
Color get animationBackgroundColor => context.colors.surface;
Color get animationTextColor => context.colors.onSurface;
```

### Темно-светлая адаптация

Анимации корректно работают в светлой и темной темах с автоматической адаптацией цветов и теней.

## Производительность и оптимизация

### Лучшие практики

1. **Используйте TickerProviderStateMixin** для оптимальной производительности
2. **Правильно dispose контроллеры** для предотвращения утечек памяти
3. **Проверяйте mounted** перед запуском анимаций
4. **Используйте AnimatedBuilder** вместо setState для анимаций
5. **Ограничивайте количество одновременных анимаций**

### Мониторинг производительности

```dart
// Добавление мониторинга FPS в debug режиме
if (kDebugMode) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Мониторинг производительности анимаций
  });
}
```

## Доступность

### Уважение к предпочтениям пользователей

```dart
// Проверка настроек reduced motion
final bool reduceMotion = MediaQuery.of(context).accessibleNavigation;

if (!reduceMotion) {
  // Запуск анимаций
  _controller.forward();
} else {
  // Пропуск анимаций
  _controller.value = 1.0;
}
```

### Альтернативные решения

Для пользователей с чувствительностью к движению предоставляются альтернативные статичные интерфейсы.

## Тестирование анимаций

### Unit тесты

```dart
testWidgets('Animation controller test', (WidgetTester tester) async {
  await tester.pumpWidget(MyAnimatedWidget());
  
  // Проверка начального состояния
  expect(find.byType(AnimatedContainer), findsOneWidget);
  
  // Запуск анимации
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Проверка состояния после анимации
  await tester.pumpAndSettle();
});
```

### Интеграционное тестирование

```dart
integrationTest('Page transition animation', () async {
  await integrationDriver();
});
```

## Будущие улучшения

### Планируемые функции

1. **Lottie анимации** для сложных motion design
2. **Физические анимации** с реалистичной физикой
3. **Генеративные анимации** на основе AI
4. **Адаптивные анимации** на основе поведения пользователя
5. **Voice-activated animations** для голосового управления

### Технические улучшения

1. **Pre-built animation library** для переиспользуемых анимаций
2. **Animation performance monitoring** в продакшене
3. **A/B testing** для различных вариантов анимаций
4. **Accessibility testing** для анимаций

## Заключение

Система анимаций ACS предоставляет мощный и гибкий фреймворк для создания современных, производительных и доступных анимаций во всем приложении. Следуя принципам и паттернам, описанным в этой документации, разработчики могут создавать согласованный и привлекательный пользовательский опыт на всех экранах приложения.