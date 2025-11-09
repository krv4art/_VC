import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class DatabaseTestScreen extends StatelessWidget {
  const DatabaseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Database Test', showBackButton: true),
      body: const Center(child: Text('Database Test Screen')),
    );
  }
}
