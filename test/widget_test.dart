import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_task/domain/enitities/task.dart';
import 'package:todo_task/presentation/bloc/task_bloc.dart';
import 'package:todo_task/presentation/screens/task_screen.dart';

// Mock TaskBloc class
class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
  });



  testWidgets('should display tasks', (WidgetTester tester) async {
    // Set up the state with TasksLoaded
    when(mockTaskBloc.state).thenReturn(
      TasksLoaded([
        Task(id: '1', description: 'Task 1'),
        Task(id: '2', description: 'Task 2'),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    await tester.pump(); // Ensure widget is rebuilt

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });


  testWidgets('should add a task', (WidgetTester tester) async {
    // Set up the state with TasksLoaded
    when(mockTaskBloc.state).thenReturn(TasksLoaded([]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    // Open the Add Task dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for dialog to open

    // Enter task description and add it
    const newTaskDescription = 'New Task';
    await tester.enterText(find.byType(TextField), newTaskDescription);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle(); // Wait for dialog to close

    // Verify that the AddNewTask event is dispatched
    final taskId = 'task-123'; // Fixed ID for testing purposes
    final expectedTask = Task(id: taskId, description: newTaskDescription);

    // Use any to match any Task with the given description
    verify(mockTaskBloc.add(AddNewTask(Task(id: anyNamed('id') ?? UniqueKey().toString(), description: 'New Task')))).called(1);
  });

  testWidgets('should filter tasks', (WidgetTester tester) async {
    // Set up the state with TasksLoaded
    when(mockTaskBloc.state).thenReturn(
      TasksLoaded([
        Task(id: '1', description: 'Task 1', isCompleted: true),
        Task(id: '2', description: 'Task 2', isCompleted: false),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    // Open the filter menu and select "Completed"
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle(); // Wait for menu to open

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle(); // Wait for state to update

    // Verify that the FilterTasks event is dispatched
    verify(mockTaskBloc.add(FilterTasks(TaskFilter.completed))).called(1);
  });

  testWidgets('should handle loading state', (WidgetTester tester) async {
    // Set up the state with TaskLoading
    when(mockTaskBloc.state).thenReturn(TaskLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    // Verify the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should handle error state', (WidgetTester tester) async {
    // Set up the state with TaskError
    when(mockTaskBloc.state).thenReturn(TaskError('An error occurred'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    // Verify the error message is displayed
    expect(find.text('Error: An error occurred'), findsOneWidget);
  });

  testWidgets('should handle no tasks state', (WidgetTester tester) async {
    // Set up the state with TasksLoaded but no tasks
    when(mockTaskBloc.state).thenReturn(TasksLoaded([]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>(
          create: (_) => mockTaskBloc,
          child: TaskScreen(),
        ),
      ),
    );

    // Verify that no tasks are displayed
    expect(find.byType(ListTile), findsNothing);
  });
}
