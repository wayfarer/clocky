# Architecture

This document outlines the architectural decisions and patterns used in Clocky Work.

## Core Principles

1. **Feature-First Organization**
   - Code organized by feature rather than type
   - Each feature is self-contained with its own providers, screens, and widgets
   - Shared code lives in core/ and data/ directories

2. **State Management**
   - Riverpod for dependency injection and state management
   - StateNotifier for complex state handling
   - Immutable state models using Freezed

3. **Data Flow**
   ```
   UI Widget → Provider → Service → Storage
        ↑         ↓         ↓         ↓
   State Updates ← State ← Data ← Persistence
   ```

## Directory Structure

```
lib/
├── core/              # Shared core functionality
│   ├── theme/         # App theming
│   ├── constants/     # Global constants
│   └── utils/         # Shared utilities
├── data/              # Data layer
│   ├── models/        # Data models
│   ├── providers/     # Global providers
│   └── services/      # Business logic services
└── features/          # Feature modules
    ├── clients/       # Client management
    ├── projects/      # Project management
    ├── reports/       # Reporting
    └── timer/         # Time tracking
```

## Feature Module Structure

Each feature follows this structure:
```
feature/
├── providers/     # State management
├── screens/       # UI screens
└── widgets/       # Reusable widgets
```

## State Management

### Provider Pattern
```dart
// State definition
class TimerState {
  final bool isRunning;
  final Duration elapsed;
  // ...
}

// StateNotifier
class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState.initial());
  
  void start() { /* ... */ }
  void pause() { /* ... */ }
}

// Provider definition
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
```

### Data Models

Using Freezed for immutable models:
```dart
@freezed
class Client with _$Client {
  const factory Client({
    required String id,
    required String name,
    required double hourlyRate,
    String? email,
    String? notes,
  }) = _Client;
}
```

## Services Layer

Services handle business logic and external interactions:

```dart
class ExportService {
  String generateClientCsv({
    required Client client,
    required List<Project> projects,
    required List<TimeEntry> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Business logic for CSV generation
  }
}
```

## Platform-Specific Implementation

See [PLATFORM_SUPPORT.md](PLATFORM_SUPPORT.md) for detailed platform-specific implementation guidelines.

## Testing Strategy

1. **Unit Tests**
   - Business logic in services
   - Provider state management
   - Data model validation

2. **Widget Tests**
   - Individual widget behavior
   - Screen navigation
   - State integration

3. **Integration Tests**
   - End-to-end workflows
   - Platform-specific features
   - Data persistence

## Error Handling

1. **User-Facing Errors**
   ```dart
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(error.userMessage),
       backgroundColor: Colors.red,
     ),
   );
   ```

2. **Service Layer Errors**
   ```dart
   Future<Result<T>> tryOperation<T>() async {
     try {
       final result = await operation();
       return Success(result);
     } catch (e) {
       return Failure(e);
     }
   }
   ```

## Navigation

Using standard Flutter navigation with named routes:
```dart
MaterialApp(
  routes: {
    '/': (context) => MainScreen(),
    '/clients': (context) => ClientsScreen(),
    '/projects': (context) => ProjectsScreen(),
    '/timer': (context) => TimerScreen(),
    '/reports': (context) => ReportsScreen(),
  },
)
```

## Theming

Material 3 theming with light/dark mode support:
```dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: themeMode,
)
```

## Future Considerations

1. **State Persistence**
   - Consider more robust storage solutions
   - Implement proper backup/restore

2. **Offline Support**
   - Implement proper offline-first architecture
   - Add sync capabilities

3. **Performance**
   - Implement pagination for large datasets
   - Add caching layer
   - Optimize rebuild triggers