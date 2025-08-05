import 'package:flutter/material.dart';

class CreateTimerScreen extends StatelessWidget {
  const CreateTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Timer')),
      body: const Center(child: Text('Form to create timer')),
    );
  }
}
