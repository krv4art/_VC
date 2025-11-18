import 'package:flutter/material.dart';
import '../widgets/poll_widget.dart';

/// Screen for viewing and voting on feature requests
class PollsScreen extends StatelessWidget {
  const PollsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Requests'),
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
      ),
      body: const PollWidget(),
    );
  }
}
