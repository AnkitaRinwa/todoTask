

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/domain/usecases/add_task.dart';
import 'package:todo_task/domain/usecases/delete_task.dart';
import 'package:todo_task/domain/usecases/get_task.dart';
import 'package:todo_task/domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final GetTasks getTasks;

  List<Task> allTasks = [];
  TaskFilter currentFilter = TaskFilter.all;

  TaskBloc({
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getTasks,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddNewTask>(_onAddNewTask);
    on<CompleteTask>(_onCompleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<FilterTasks>(_onFilterTasks);
    on<TasksUpdated>(_onTasksUpdated);  // Add this line to handle TasksUpdated events
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
    emit(TaskLoading());
    getTasks().listen(
          (tasks) {
        add(TasksUpdated(tasks));  // Use TasksUpdated event to update the state
      },
      onError: (error) {
        emit(TaskError(error.toString()));
      },
    );
  }

  void _onAddNewTask(AddNewTask event, Emitter<TaskState> emit) async {
    await addTask(event.task);
  }

  void _onCompleteTask(CompleteTask event, Emitter<TaskState> emit) async {
    final updatedTask = event.task.copyWith(isCompleted: true);
    await updateTask(updatedTask);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) async {
    await deleteTask(event.taskId);
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskState> emit) {
    currentFilter = event.filter;
    _applyFilter(emit);
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    allTasks = event.tasks;
    _applyFilter(emit);
  }

  void _applyFilter(Emitter<TaskState> emit) {
    List<Task> filteredTasks;
    switch (currentFilter) {
      case TaskFilter.all:
        filteredTasks = allTasks;
        break;
      case TaskFilter.completed:
        filteredTasks = allTasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filteredTasks = allTasks.where((task) => !task.isCompleted).toList();
        break;
    }
    emit(TasksFiltered(filteredTasks));
  }
}
