import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/models.dart';

class TodoRepository implements TodoApi {
  static const String _kTodoList = 'k_todo';

  TodoRepository();

  @override
  Future<List<Todo>> getTodoList() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_kTodoList);
    if (json == null || json.isEmpty) {
      return [];
    }
    final jsonList = jsonDecode(json) as List<dynamic>;
    if (jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((json) => Todo.fromJson(json)).toList();
  }

  @override
  Future<void> createTodoItem(Todo item) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodoList();

    prefs.setString(_kTodoList, jsonEncode(todos..add(item)));
  }

  @override
  Future<void> updateTodoItem(Todo item) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodoList();

    final index = todos.indexWhere((e) => e.id == item.id);
    todos[index] = item;
    prefs.setString(_kTodoList, jsonEncode(todos));
  }

  @override
  Future<void> removeTodoItem(Todo item) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodoList();

    todos.removeWhere((e) => e.id == item.id);
    prefs.setString(_kTodoList, jsonEncode(todos));
  }

  @override
  Future<void> clearTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_kTodoList, '');
  }
}

abstract class TodoApi {
  Future<List<Todo>> getTodoList(); // make stream
  Future<void> createTodoItem(Todo item);
  Future<void> updateTodoItem(Todo item);
  Future<void> removeTodoItem(Todo item);
  Future<void> clearTodoList();
}
