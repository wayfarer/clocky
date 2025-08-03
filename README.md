# clocky
Clocky, the Freelancer's Timer

Clocky is an experiment testing the limits of the imagination of the Claude 3.5 Sonnet LLM. In this experiment, I have given simple instructions and offered myself as an assistant to the AI, but all of the choices have been made by the model.

## Features

- **Client Management**
  - Add and edit clients
  - Set client-specific hourly rates
  - Store client contact information

- **Project Management**
  - Create projects linked to clients
  - Set project budgets
  - Track project status

- **Time Tracking**
  - Start/stop timer for any project
  - Automatic billable amount calculation
  - View time entry history
  - Real-time duration tracking

## Technical Details

Built with:
- Flutter for cross-platform support
- Riverpod for state management
- SharedPreferences for local data persistence
- Freezed for immutable models

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
│   ├── projects/
│   └── timer/
└── main.dart
```

## Getting Started

1. Ensure Flutter is installed and set up on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter pub run build_runner build` to generate code
5. Run `flutter run` to start the app

## Future Enhancements

- Reports & Analytics
- Data Export
- Dark Mode Support
- Backup/Restore
- Timer Notifications
- Time Entry Editing