import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/training_session.dart';

class PracticeResultsScreen extends StatelessWidget {
  final TrainingSession? session;

  const PracticeResultsScreen({
    super.key,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты тренировки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Text('Результаты тренировки'),
      ),
    );
  }
}
