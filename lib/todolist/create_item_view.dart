import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/models.dart';
import 'package:todo/todolist/bloc/todolist_bloc.dart';

class CreateTodoItemView extends StatefulWidget {
  const CreateTodoItemView({super.key});

  @override
  State<CreateTodoItemView> createState() => _CreateTodoItemViewState();
}

class _CreateTodoItemViewState extends State<CreateTodoItemView> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(child: TextField(controller: textController)),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _onTap,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    if (textController.text.isEmpty) return;
    context
        .read<TodoListBloc>()
        .add(TodoListItemCreated(Todo(title: textController.text)));
    textController.clear();
  }
}
