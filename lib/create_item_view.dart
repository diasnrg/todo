import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/models/models.dart';
import 'package:todo/todolist/bloc/todolist_bloc.dart';

class CreateTodoItemButton extends StatelessWidget {
  const CreateTodoItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (context) => const CreateTodoItemView(),
      ),
      backgroundColor: Theme.of(context).toggleableActiveColor,
      child: const Icon(Icons.add),
    );
  }
}

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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          children: [
            _textField,
            const SizedBox(width: 16),
            _createButton,
          ],
        ),
      ),
    );
  }

  Widget get _textField {
    return Expanded(
      child: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'New todo item',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget get _createButton {
    return InkWell(
      onTap: _createTodoItem,
      child: Text(
        'Save',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _createTodoItem() {
    if (textController.text.isEmpty) return;
    context
        .read<TodoListBloc>()
        .add(TodoListItemCreated(Todo(title: textController.text)));
    Navigator.of(context).pop();
  }
}
