import 'package:flutter/material.dart';
import 'package:tasker_offline/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TaskerApp());
}

class TaskerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tasker App",
      home: HomeScreen(),
    );
  }
}
