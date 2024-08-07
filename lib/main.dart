
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/data/data_source/task_data_source.dart';
import 'package:todo_task/data/repositories/data_task_repository.dart';
import 'package:todo_task/domain/usecases/add_task.dart';
import 'package:todo_task/domain/usecases/delete_task.dart';
import 'package:todo_task/domain/usecases/get_task.dart';
import 'package:todo_task/domain/usecases/update_task.dart';
import 'package:todo_task/presentation/screens/task_screen.dart';

import 'presentation/bloc/task_bloc.dart';


void main() {
  final taskDataSource = TaskDataSource();
  final taskRepository = TaskRepositoryImpl(taskDataSource);

  runApp(
      BlocProvider<TaskBloc>(
      create: (_) => TaskBloc(
    addTask: AddTask(taskRepository),
    updateTask: UpdateTask(taskRepository),
    deleteTask: DeleteTask(taskRepository),
    getTasks: GetTasks(taskRepository),
  )..add(LoadTasks()),
  child: MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
     TaskScreen()
    );
  }
}
