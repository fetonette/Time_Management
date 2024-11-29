part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;

  TaskLoadSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskAdded extends TaskState {}

class TaskDeleted extends TaskState {}

class TaskUpdated extends TaskState {
  final Task newTask;

    TaskUpdated(this.newTask);

  @override
  List<Object?> get props => [newTask];

}

class TaskLoadFailure extends TaskState {
  final String message;

  TaskLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
