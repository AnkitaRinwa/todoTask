

import 'package:todo_task/data/data_source/task_data_source.dart';
import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<void> addTask(Task task) async {
    await dataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await dataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await dataSource.deleteTask(id);
  }

  @override
  Stream<List<Task>> getTasks() {
    return dataSource.tasksStream;
  }
}
