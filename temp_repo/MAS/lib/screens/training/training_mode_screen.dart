import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrainingModeScreen extends StatelessWidget {
  const TrainingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренуйся'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'Режим тренировки',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Отсканируйте пример задачи,\nи AI сгенерирует похожие для практики',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('В разработке')),
                );
              },
              icon: const Icon(Icons.camera),
              label: const Text('Начать тренировку'),
            ),
          ],
        ),
      ),
    );
  }
}
