import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InterviewQuestionsScreen extends StatelessWidget {
  const InterviewQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = [
      {
        'name': 'General Questions',
        'icon': Icons.question_answer,
        'questions': [
          {
            'question': 'Tell me about yourself',
            'answer':
                'Focus on your professional journey, highlighting relevant experiences and skills. Keep it concise (2-3 minutes) and connect it to why you\'re a great fit for this role.',
          },
          {
            'question': 'What are your greatest strengths?',
            'answer':
                'Choose 2-3 strengths that are relevant to the job. Provide specific examples of how you\'ve demonstrated these strengths in previous roles.',
          },
          {
            'question': 'Where do you see yourself in 5 years?',
            'answer':
                'Show ambition while staying realistic. Align your goals with potential growth within the company. Demonstrate your commitment to professional development.',
          },
        ],
      },
      {
        'name': 'Technical Skills',
        'icon': Icons.computer,
        'questions': [
          {
            'question': 'Describe your technical expertise',
            'answer':
                'Highlight your proficiency in relevant technologies and tools. Provide examples of projects where you\'ve applied these skills successfully.',
          },
          {
            'question': 'How do you stay updated with new technologies?',
            'answer':
                'Mention specific resources (blogs, courses, conferences). Show your commitment to continuous learning and professional growth.',
          },
        ],
      },
      {
        'name': 'Behavioral Questions',
        'icon': Icons.psychology,
        'questions': [
          {
            'question': 'Describe a challenging situation and how you handled it',
            'answer':
                'Use the STAR method (Situation, Task, Action, Result). Choose an example that demonstrates problem-solving, leadership, or teamwork skills.',
          },
          {
            'question': 'Tell me about a time you failed',
            'answer':
                'Be honest but focus on what you learned. Show how you\'ve grown from the experience and applied those lessons to subsequent situations.',
          },
          {
            'question': 'How do you handle conflict with team members?',
            'answer':
                'Emphasize communication, empathy, and finding mutually beneficial solutions. Provide a specific example if possible.',
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Questions'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.space16),
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          final questions = category['questions'] as List<Map<String, String>>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.space16),
                child: Row(
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: AppTheme.space12),
                    Text(
                      category['name'] as String,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              ...questions.map((qa) => _QuestionCard(
                    question: qa['question']!,
                    answer: qa['answer']!,
                  )),
              const SizedBox(height: AppTheme.space24),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  final String question;
  final String answer;

  const _QuestionCard({
    required this.question,
    required this.answer,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.space12),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: AppTheme.space12),
                Container(
                  padding: const EdgeInsets.all(AppTheme.space12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Text(
                    widget.answer,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
