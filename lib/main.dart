import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/repository.dart';
import 'package:todo/todolist/todolist_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository =
      TodoRepository(storage: await SharedPreferences.getInstance());
  runApp(App(repository: repository));
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.repository,
  });

  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo'),
        ),
        body: RepositoryProvider.value(
          value: repository,
          child: const TodoListPage(),
        ),
      ),
    );
  }
}
