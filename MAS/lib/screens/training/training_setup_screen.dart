import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/math_expression.dart';

/// Screen for setting up training session parameters
class TrainingSetupScreen extends StatefulWidget {
  const TrainingSetupScreen({super.key});

  @override
  State<TrainingSetupScreen> createState() => _TrainingSetupScreenState();
}

class _TrainingSetupScreenState extends State<TrainingSetupScreen> {
  DifficultyLevel _selectedDifficulty = DifficultyLevel.medium;
  ExpressionType _selectedType = ExpressionType.equation;
  int _problemCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Налаштування тренування'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDifficultySelector(),
            const SizedBox(height: 20),
            _buildTypeSelector(),
            const SizedBox(height: 20),
            _buildProblemCountSelector(),
            const SizedBox(height: 32),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fitness_center, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Налаштуйте тренування',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Виберіть складність і тип задач',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Складність', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _DifficultyOption(
              level: DifficultyLevel.easy,
              selected: _selectedDifficulty == DifficultyLevel.easy,
              onTap: () => setState(() => _selectedDifficulty = DifficultyLevel.easy),
            ),
            const SizedBox(height: 12),
            _DifficultyOption(
              level: DifficultyLevel.medium,
              selected: _selectedDifficulty == DifficultyLevel.medium,
              onTap: () => setState(() => _selectedDifficulty = DifficultyLevel.medium),
            ),
            const SizedBox(height: 12),
            _DifficultyOption(
              level: DifficultyLevel.hard,
              selected: _selectedDifficulty == DifficultyLevel.hard,
              onTap: () => setState(() => _selectedDifficulty = DifficultyLevel.hard),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Тип задач', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TypeChip(ExpressionType.equation, _selectedType, (t) => setState(() => _selectedType = t)),
                _TypeChip(ExpressionType.inequality, _selectedType, (t) => setState(() => _selectedType = t)),
                _TypeChip(ExpressionType.expression, _selectedType, (t) => setState(() => _selectedType = t)),
                _TypeChip(ExpressionType.derivative, _selectedType, (t) => setState(() => _selectedType = t)),
                _TypeChip(ExpressionType.integral, _selectedType, (t) => setState(() => _selectedType = t)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCountSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Кількість задач: $_problemCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Slider(
              value: _problemCount.toDouble(),
              min: 3,
              max: 10,
              divisions: 7,
              activeColor: Colors.orange,
              onChanged: (value) => setState(() => _problemCount = value.round()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Генерація задач скоро буде доступна')),
          );
        },
        icon: const Icon(Icons.play_arrow, size: 28),
        label: const Text('Почати тренування', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final DifficultyLevel level;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyOption({required this.level, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = level == DifficultyLevel.easy ? Colors.green : level == DifficultyLevel.medium ? Colors.orange : Colors.red;
    final label = level == DifficultyLevel.easy ? 'Легкий' : level == DifficultyLevel.medium ? 'Середній' : 'Складний';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : Colors.grey.shade300, width: 2),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: color),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final ExpressionType type;
  final ExpressionType selected;
  final Function(ExpressionType) onSelect;

  const _TypeChip(this.type, this.selected, this.onSelect);

  String get label {
    switch (type) {
      case ExpressionType.equation: return 'Рівняння';
      case ExpressionType.inequality: return 'Нерівність';
      case ExpressionType.expression: return 'Вираз';
      case ExpressionType.derivative: return 'Похідна';
      case ExpressionType.integral: return 'Інтеграл';
      default: return type.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: Colors.orange.shade100,
      checkmarkColor: Colors.orange,
      onSelected: (_) => onSelect(type),
    );
  }
}
