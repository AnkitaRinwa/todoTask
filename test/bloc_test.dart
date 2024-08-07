import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/domain/usecases/add_task.dart';
import 'package:todo_task/domain/usecases/update_task.dart';
import 'package:todo_task/domain/usecases/delete_task.dart';
import 'package:todo_task/domain/usecases/get_task.dart';

// Define the mock class
class MockAddTask extends Mock implements AddTask {}
class MockUpdateTask extends Mock implements UpdateTask {}
class MockDeleteTask extends Mock implements DeleteTask {}
class MockGetTasks extends Mock implements GetTasks {}

void main() {
  late MockAddTask mockAddTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;
  late MockGetTasks mockGetTasks;

  setUp(() {
    mockAddTask = MockAddTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();
    mockGetTasks = MockGetTasks();

    // Ensure correct mock setup
    when(mockAddTask(Task(id: '1', description: "Task1",isCompleted: false))).thenAnswer((_) async {});
    when(mockUpdateTask(Task(id: '1', description: "Task1",isCompleted: true))).thenAnswer((_) async {});
    when(mockDeleteTask('1')).thenAnswer((_) async {});
    when(mockGetTasks()).thenAnswer((_) => Stream.value([]));
  });

  test('AddTask should call addTask on the repository', () async {
    final task = Task(id: '1', description: 'Test Task');

    await mockAddTask(task);

    verify(mockAddTask(task)).called(1);
  });

  test('UpdateTask should call updateTask on the repository', () async {
    final task = Task(id: '1', description: 'Updated Task');

    await mockUpdateTask(task);

    verify(mockUpdateTask(task)).called(1);
  });

  test('DeleteTask should call deleteTask on the repository', () async {
    final taskId = '1';

    await mockDeleteTask(taskId);

    verify(mockDeleteTask(taskId)).called(1);
  });

  test('GetTasks should return a stream of tasks', () async {
    final taskList = [
      Task(id: '1', description: 'Test Task 1'),
      Task(id: '2', description: 'Test Task 2'),
    ];

    when(mockGetTasks()).thenAnswer((_) => Stream.value(taskList));

    final result = mockGetTasks();
    expect(await result.toList(), taskList);
  });
}
