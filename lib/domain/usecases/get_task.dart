import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<List<Task>> call() {
    return repository.getTasks();
  }
}