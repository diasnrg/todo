import 'dart:async';
import 'dart:convert';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/models.dart';

class TodoRepository implements TodoApi {
  static const String _kTodoList = 'k_todo';

  TodoRepository({required this.storage}) {
    _init();
  }

  final SharedPreferences storage;

  // simple StreamController does not return the last element for a new listener
  final _streamController = BehaviorSubject<List<Todo>>();

  void _init() {
    final json = storage.getString(_kTodoList);
    if (json == null || json.isEmpty) {
      return _streamController.add([]);
    }

    final jsonList = jsonDecode(json) as List<dynamic>;
    if (jsonList.isEmpty) {
      return _streamController.add([]);
    }
    return _streamController
        .add(jsonList.map((e) => Todo.fromJson(e)).toList());
  }

  @override
  Stream<List<Todo>> get todolistStream =>
      _streamController.asBroadcastStream();

  @override
  Future<void> createTodoItem(Todo item) async {
    // create new list object, otherwise state will not update because of the reference to the same object.
    final todolist = List<Todo>.from(_streamController.value);
    todolist.add(item);
    return _updateTodoList(todolist);
  }

  @override
  Future<void> updateTodoItem(Todo item) async {
    final todolist = List<Todo>.from(_streamController.value);
    final index = todolist.indexWhere((e) => e.id == item.id);
    todolist[index] = item;
    return _updateTodoList(todolist);
  }

  @override
  Future<void> removeTodoItem(Todo item) async {
    final todolist = List<Todo>.from(_streamController.value);
    todolist.removeWhere((e) => e.id == item.id);
    return _updateTodoList(todolist);
  }

  Future<void> _updateTodoList(List<Todo> todolist) {
    _streamController.add(todolist);
    return storage.setString(_kTodoList, jsonEncode(todolist));
  }

  @override
  Future<void> clearTodoList() async {
    storage.setString(_kTodoList, '');
  }
}

abstract class TodoApi {
  Stream<List<Todo>> get todolistStream;
  Future<void> createTodoItem(Todo item);
  Future<void> updateTodoItem(Todo item);
  Future<void> removeTodoItem(Todo item);
  Future<void> clearTodoList();
}
