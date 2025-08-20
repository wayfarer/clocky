import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/services/storage_service.dart';
import '../../clients/providers/clients_provider.dart';

class TimerState {
  final TimeEntry? currentEntry;
  final Duration? displayDuration;
  final List<TimeEntry> savedEntries;

  TimerState({
    this.currentEntry,
    this.displayDuration,
    this.savedEntries = const [],
  });

  bool get isRunning => currentEntry != null;

  TimerState copyWith({
    TimeEntry? currentEntry,
    Duration? displayDuration,
    List<TimeEntry>? savedEntries,
  }) {
    return TimerState(
      currentEntry: currentEntry ?? this.currentEntry,
      displayDuration: displayDuration ?? this.displayDuration,
      savedEntries: savedEntries ?? this.savedEntries,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  final StorageService _storage;
  Timer? _timer;

  TimerNotifier(this._storage) : super(TimerState()) {
    _loadSavedEntries();
  }

  Future<void> _loadSavedEntries() async {
    final entries = await _storage.getTimeEntries();
    state = state.copyWith(savedEntries: entries);
  }

  void startTimer({
    required String projectId,
    String? description,
    bool isBillable = true,
  }) {
    if (state.currentEntry != null) return;

    final entry = TimeEntry.create(
      projectId: projectId,
      description: description,
      isBillable: isBillable,
    );

    state = state.copyWith(
      currentEntry: entry,
      displayDuration: Duration.zero,
    );

    _startTicking();
  }

  Future<void> stopTimer() async {
    if (state.currentEntry == null) return;

    _timer?.cancel();
    _timer = null;  // Clear the timer reference
    
    final completedEntry = state.currentEntry!.copyWith(
      endTime: DateTime.now(),
    );

    await _storage.saveTimeEntry(completedEntry);
    
    final updatedEntries = [...state.savedEntries, completedEntry];
    state = TimerState(  // Create a fresh state
      currentEntry: null,
      displayDuration: null,
      savedEntries: updatedEntries,
    );
  }

  Future<void> submitCurrentTime() async {
    if (state.currentEntry == null) return;

    _timer?.cancel();
    _timer = null;  // Clear the timer reference
    
    // Force end the timer and save it regardless of current state
    final submittedEntry = state.currentEntry!.copyWith(
      endTime: DateTime.now(),
    );

    await _storage.saveTimeEntry(submittedEntry);
    
    final updatedEntries = [...state.savedEntries, submittedEntry];
    state = TimerState(  // Create a fresh state
      currentEntry: null,
      displayDuration: null,
      savedEntries: updatedEntries,
    );
  }

  Future<void> updateTimeEntry(TimeEntry entry) async {
    await _storage.saveTimeEntry(entry);
    
    final updatedEntries = [
      for (final e in state.savedEntries)
        if (e.id == entry.id) entry else e
    ];
    
    state = state.copyWith(savedEntries: updatedEntries);
  }

  Future<void> deleteTimeEntry(TimeEntry entry) async {
    final updatedEntries = state.savedEntries.where((e) => e.id != entry.id).toList();
    state = state.copyWith(savedEntries: updatedEntries);
    
    // Update storage to reflect deletion
    await _storage.saveTimeEntries(updatedEntries);
  }

  void pauseTimer() {
    if (state.currentEntry == null) return;
    
    _timer?.cancel();
    _timer = null;

    final pausedEntry = state.currentEntry!.pause();
    state = state.copyWith(currentEntry: pausedEntry);
  }

  void resumeTimer() {
    if (state.currentEntry == null) return;
    
    final resumedEntry = state.currentEntry!.resume();
    state = state.copyWith(currentEntry: resumedEntry);
    
    _startTicking();
  }

  void discardTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(
      currentEntry: null,
      displayDuration: null,
    );
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.currentEntry == null) return;
      state = state.copyWith(
        displayDuration: state.currentEntry!.duration,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return TimerNotifier(storage);
});