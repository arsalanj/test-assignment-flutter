import 'package:flutter/material.dart';

class TimerListScreen extends StatelessWidget {
  const TimerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timers')),
      body: const Center(child: Text('Timer list goes here')),
    );
  }
}
