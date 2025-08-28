import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/clients/screens/clients_screen.dart';
import 'features/projects/screens/project_dashboard_screen.dart';
import 'features/timer/screens/timer_screen.dart';
import 'features/reports/screens/reports_screen.dart';
import 'features/timer/widgets/running_timer_indicator.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Clocky Work',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainScreen(),
      builder: (context, child) {
        return IconTheme(
          data: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          child: child!,
        );
      },
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.schedule, size: 24),
              SizedBox(width: 8),
              Text(
                'Clocky Work ',
                style: GoogleFonts.rubikVinyl(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Work',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            const RunningTimerIndicator(),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            TimerScreen(),
            ProjectDashboardScreen(),
            ClientsScreen(),
            ReportsScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.timer), text: 'Timer'),
            Tab(icon: Icon(Icons.folder), text: 'Projects'),
            Tab(icon: Icon(Icons.people), text: 'Clients'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
          ],
        ),
      ),
    );
  }
}