# AI Context

This document provides context for AI agents working on the Clocky project.

## Project Overview

Clocky is a Flutter-based time tracking application for freelancers. The project demonstrates an experimental approach where the AI (Claude 3.5 Sonnet) acts as the primary architect and developer, with human developers in an assistant role.

## Core Features

- Client management with hourly rates
- Project tracking with budgets
- Time entry system with pause/resume
- Reports and analytics
- Project dashboard with progress tracking

## Architecture Decisions

The project follows these architectural principles:

1. **State Management**: Uses Riverpod for dependency injection and state management
2. **Data Models**: Implements immutable models using Freezed
3. **Local Storage**: Uses SharedPreferences for data persistence
4. **Feature Organization**: Follows a feature-first folder structure
5. **UI Components**: Leverages Material Design 3 with custom theming

## Development Guidelines

When contributing to this project, AI agents should:

1. **Make Architectural Decisions**
   - Design new features and components
   - Plan implementation approaches
   - Structure code organization

2. **Write Code**
   - Implement new features
   - Fix bugs and issues
   - Write tests (when implemented)

3. **Provide Documentation**
   - Document new features
   - Explain architectural decisions
   - Update README and other docs

4. **Review and Respond**
   - Review human feedback
   - Suggest improvements
   - Address concerns

## Working with Humans

In this project, humans act as assistants to the AI. AI agents should:

1. **Give Clear Instructions**
   - Provide specific implementation steps
   - Explain the reasoning behind decisions
   - Break down complex tasks

2. **Request Feedback**
   - Ask for testing results
   - Seek input on UX decisions
   - Confirm feature requirements

3. **Handle Operations**
   - Provide git commands
   - Explain build steps
   - Guide through testing

## Code Style

Follow these principles:
- Clear, descriptive variable and function names
- Consistent widget structure
- Proper error handling
- Separation of concerns
- DRY (Don't Repeat Yourself)

## Feature Implementation Process

1. **Planning**
   - Define feature requirements
   - Design data models
   - Plan UI components

2. **Implementation**
   - Create necessary files
   - Implement core logic
   - Build UI components
   - Add error handling

3. **Review**
   - Request human testing
   - Address feedback
   - Make improvements

4. **Documentation**
   - Update documentation
   - Provide usage examples
   - Document edge cases

## Current Project State

The project currently has:
- Basic client/project management
- Time tracking with pause/resume
- Reports with date filtering
- Project dashboard
- Dark/light theme support

Future AI agents should build upon this foundation while maintaining the established patterns and architecture.