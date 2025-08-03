import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/clients/screens/clients_screen.dart';
import 'features/projects/screens/projects_screen.dart';
import 'features/timer/screens/timer_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clocky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const TabBarView(
          children: [
            TimerScreen(),
            ProjectsScreen(),
            ClientsScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.timer), text: 'Timer'),
            Tab(icon: Icon(Icons.folder), text: 'Projects'),
            Tab(icon: Icon(Icons.people), text: 'Clients'),
          ],
        ),
      ),
    );
  }
}