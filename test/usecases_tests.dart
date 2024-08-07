import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/domain/repositories/task_repository.dart';
import 'package:todo_task/domain/usecases/add_task.dart';
import 'package:todo_task/domain/usecases/delete_task.dart';
import 'package:todo_task/domain/usecases/get_task.dart';
import 'package:todo_task/domain/usecases/update_task.dart';
import 'usecases_tests.mocks.dart'; // Import the generated file

// Generate mocks for the TaskRepository class
@GenerateMocks([TaskRepository])

void main() {
 late MockTaskRepository mockTaskRepository;
  late AddTask addTask;
  late UpdateTask updateTask;
  late DeleteTask deleteTask;
  late GetTasks getTasks;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    addTask = AddTask(mockTaskRepository);
    updateTask = UpdateTask(mockTaskRepository);
    deleteTask = DeleteTask(mockTaskRepository);
    getTasks = GetTasks(mockTaskRepository);
  });

  test('AddTask should call addTask on the repository', () async {
    final task = Task(id: '1', description: 'Test Task');

    when(mockTaskRepository.addTask(any)).thenAnswer((_) async {});

    await addTask(task);

    verify(mockTaskRepository.addTask(task)).called(1);
  });

  test('UpdateTask should call updateTask on the repository', () async {
    final task = Task(id: '1', description: 'Updated Task');

    // Mock the repository method
    when(mockTaskRepository.updateTask(any)).thenAnswer((_) async {});

    // Execute the use case
    await updateTask(task);

    // Verify that the repository method was called with the correct task
    verify(mockTaskRepository.updateTask(argThat(equals(task)))).called(1);
  });

  test('DeleteTask should call deleteTask on the repository', () async {
    const taskId = '1';

    when(mockTaskRepository.deleteTask(any)).thenAnswer((_) async {});

    await deleteTask(taskId);

    verify(mockTaskRepository.deleteTask(taskId)).called(1);
  });

  test('GetTasks should call getTasks on the repository and return a stream', () async {
    final taskList = <Task>[
      Task(id: '1', description: 'Test Task 1'),
      Task(id: '2', description: 'Test Task 2'),
    ];

    // Mock the getTasks method to return a stream that emits taskList
    when(mockTaskRepository.getTasks()).thenAnswer((_) => Stream.fromIterable([taskList]));

    // Call the use case
    final resultStream = getTasks();

    // Retrieve the first (and only) list from the stream
    final tasks = await resultStream.first;

    // Compare the result to the expected list
    expect(tasks, equals(taskList));
    verify(mockTaskRepository.getTasks()).called(1);
  });


  test('AddTask should handle repository errors', () async {
    final task = Task(id: '1', description: 'Test Task');

    when(mockTaskRepository.addTask(any)).thenThrow(Exception('Database error'));

    expect(() => addTask(task), throwsA(isA<Exception>()));

    verify(mockTaskRepository.addTask(task)).called(1);
  });

  test('UpdateTask should handle repository errors', () async {
    final task = Task(id: '1', description: 'Updated Task');

    when(mockTaskRepository.updateTask(any)).thenThrow(Exception('Database error'));

    expect(() => updateTask(task), throwsA(isA<Exception>()));

    verify(mockTaskRepository.updateTask(task)).called(1);
  });

  test('DeleteTask should handle repository errors', () async {
    const taskId = '1';

    when(mockTaskRepository.deleteTask(any)).thenThrow(Exception('Database error'));

    expect(() => deleteTask(taskId), throwsA(isA<Exception>()));

    verify(mockTaskRepository.deleteTask(taskId)).called(1);
  });

  test('GetTasks should handle repository errors', () async {
    when(mockTaskRepository.getTasks()).thenThrow(Exception('Database error'));

    expect(() => getTasks().toList(), throwsA(isA<Exception>()));

    verify(mockTaskRepository.getTasks()).called(1);
  });
}
