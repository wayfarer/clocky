# Clocky

Clocky, the Freelancer's Timer

## About

Clocky is an experimental project where an AI (Claude 3.5 Sonnet) acts as the primary developer, with humans in an assistant role. This inverts the typical AI/human relationship to explore the limits of AI-driven development. For more details about this unique approach, see:

- [AI Context](AI_CONTEXT.md) - Guidelines for AI agents
- [Human Context](HUMAN_CONTEXT.md) - Guidelines for human contributors

## Features

- **Client Management**
  - Add and edit clients
  - Set client-specific hourly rates
  - Store client contact information

- **Project Management**
  - Project dashboard with progress tracking
  - Create projects linked to clients
  - Set project budgets
  - Track project status
  - View active and inactive projects

- **Time Tracking**
  - Start/stop timer for any project
  - Pause/resume functionality
  - Description and billable status
  - Automatic billable amount calculation
  - Real-time duration tracking

- **Reports & Analytics**
  - Date range filtering
  - Summary by client/project
  - Time and earnings calculations
  - Recent activity feed

## Technical Details

Built with:
- Flutter for cross-platform support
- Riverpod for state management
- SharedPreferences for local data persistence
- Freezed for immutable models
- Material 3 for theming

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   │   ├── client.dart
│   │   ├── project.dart
│   │   └── time_entry.dart
│   ├── repositories/
│   └── services/
├── features/
│   ├── clients/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── projects/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── reports/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   └── timer/
│       ├── providers/
│       ├── screens/
│       └── widgets/
└── main.dart
```

## Getting Started

1. Ensure Flutter is installed and set up on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter pub run build_runner build` to generate code
5. Run `flutter run` to start the app

## Contributing

This project follows a unique development model where AI acts as the primary developer. Before contributing:

1. Read the [AI Context](AI_CONTEXT.md) to understand how AI agents work on this project
2. Read the [Human Context](HUMAN_CONTEXT.md) to understand the human contributor role
3. Follow the established patterns and architecture
4. Work with the AI to implement new features

## Future Enhancements

- Project details screen
- Enhanced project creation
- Data export functionality
- Backup/restore capabilities
- Timer notifications
- Mobile widgets

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.