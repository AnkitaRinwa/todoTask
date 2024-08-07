

import 'dart:async';

import 'package:todo_task/domain/enitities/task.dart';

class TaskDataSource {
  final _tasks = <Task>[];
  final _taskStreamController = StreamController<List<Task>>.broadcast();

  TaskDataSource() {
    _taskStreamController.add(_tasks);
  }

  Stream<List<Task>> get tasksStream => _taskStreamController.stream;

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    _taskStreamController.add(_tasks);
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _taskStreamController.add(_tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _taskStreamController.add(_tasks);
  }
}
