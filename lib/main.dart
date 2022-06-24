import 'package:flutter/material.dart';
import 'package:todo/todolist/todolist_view.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo'),
        ),
        body: const TodoListPage(),
      ),
    );
  }
}
