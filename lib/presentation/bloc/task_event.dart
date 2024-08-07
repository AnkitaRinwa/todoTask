part of 'task_bloc.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddNewTask extends TaskEvent {
  final Task task;
  AddNewTask(this.task);
}

class CompleteTask extends TaskEvent {
  final Task task;
  CompleteTask(this.task);
}

class RemoveTask extends TaskEvent {
  final String taskId;
  RemoveTask(this.taskId);
}

class FilterTasks extends TaskEvent {
  final TaskFilter filter;
  FilterTasks(this.filter);
}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}

enum TaskFilter { all, completed, pending }
