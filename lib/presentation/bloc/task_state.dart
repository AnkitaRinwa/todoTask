
part of 'task_bloc.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  TasksLoaded(this.tasks);
}

class TasksFiltered extends TaskState {
  final List<Task> filteredTasks;
  TasksFiltered(this.filteredTasks);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
