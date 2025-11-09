import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SolutionHistoryScreen extends StatelessWidget {
  const SolutionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final mockSolutions = [
      {'title': 'x² + 5x + 6 = 0', 'date': '15 хв тому', 'difficulty': 'Легко', 'color': Colors.green},
      {'title': '∫(2x + 3)dx', 'date': '2 години тому', 'difficulty': 'Середнє', 'color': Colors.orange},
      {'title': 'lim(x→∞) (x²+1)/(2x²-3)', 'date': 'Вчора', 'difficulty': 'Складно', 'color': Colors.red},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Історія розв\'язань'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: mockSolutions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 24),
                  Text(
                    'Історія розв\'язань',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Тут будуть збережені рішення',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockSolutions.length,
              itemBuilder: (context, index) {
                final solution = mockSolutions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.functions, color: AppTheme.primaryPurple),
                    ),
                    title: Text(
                      solution['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (solution['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            solution['difficulty'] as String,
                            style: TextStyle(
                              color: solution['color'] as Color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(solution['date'] as String),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Перегляд збережених рішень скоро буде доступний')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
