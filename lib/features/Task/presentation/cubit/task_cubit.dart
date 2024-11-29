import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/Task/domain/entities/Task.dart';
import 'package:myapp/features/Task/domain/usecases/create_task.dart';
import 'package:myapp/features/Task/domain/usecases/delete_task.dart';
import 'package:myapp/features/Task/domain/usecases/read_task.dart';
import 'package:myapp/features/Task/domain/usecases/update_task.dart';

part 'task_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will synce once you're back online.";

// Define the TaskCubit
class TaskCubit extends Cubit<TaskState> {
  final CreateTask _createTaskUseCase;
  final GetTasks _readTaskUseCase;
  final UpdateTask _updateTaskUseCase;
  final DeleteTask _deleteTaskUseCase;

  TaskCubit({
    required CreateTask createTaskUseCase,
    required GetTasks readTaskUseCase,
    required UpdateTask updateTaskUseCase,
    required DeleteTask deleteTaskUseCase,
  })  : _deleteTaskUseCase = deleteTaskUseCase, _updateTaskUseCase = updateTaskUseCase, _readTaskUseCase = readTaskUseCase,
        _createTaskUseCase = createTaskUseCase,
        super(TaskInitial());

  // Load tasks from the use case
  Future<void> loadTasks({
    DateTime? deadline,
    int? priority,
    String? subject,
  }) async {
    emit(TaskLoadInProgress());

    try {
      final result = await _readTaskUseCase
          .call(deadline: deadline, priority: priority, subject: subject)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) {
          emit(TaskLoadFailure(failure.getMessage()));
        },
        (tasks) {
          emit(TaskLoadSuccess(tasks));
        },
      );
    } on TimeoutException catch (_) {
      emit(TaskLoadFailure(
          "There seem to be a problem with your internet connection"));
    }
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    emit(TaskLoadInProgress());

    try {
      final result = await _createTaskUseCase.call(task).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) {
          emit(TaskLoadFailure(failure.getMessage()));
        },
        (_) {
          emit(TaskAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(TaskLoadFailure(noInternetErrorMessage));
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    emit(TaskLoadInProgress());

    try {
      final result = await _updateTaskUseCase.call(task).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) {
          emit(TaskLoadFailure(
              failure.getMessage())); // Emit failure state with message
        },
        (_) {
          emit(TaskUpdated(task));
        },
      );
    } on TimeoutException catch (_) {
      emit(TaskLoadFailure(noInternetErrorMessage));
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    emit(TaskLoadInProgress());

    try {
      final result = await _deleteTaskUseCase.call(taskId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) {
          emit(TaskLoadFailure(
              failure.getMessage())); // Emit failure state with message
        },
        (_) {
          emit(TaskDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(TaskLoadFailure(noInternetErrorMessage));
    }
  }
}
