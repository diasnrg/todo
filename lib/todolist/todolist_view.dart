import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models.dart';
import 'package:todo/todolist/bloc/todolist_event.dart';
import 'package:todo/todolist/bloc/todolist_state.dart';
import 'package:todo/todolist/create_item_view.dart';
import 'bloc/todolist_bloc.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoListBloc(),
      child: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CreateTodoItemView()),
          TodoListView(),
        ],
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(builder: (context, state) {
      if (state.status == TodoListStatus.failure) {
        return const SliverToBoxAdapter(child: Text('error occured'));
      }

      final todos = state.todos;
      if (todos.isEmpty) {
        return const SliverToBoxAdapter(
            child: Center(child: Text('empty list')));
      }

      return SliverList(
        delegate: SliverChildListDelegate(
          todos.map((e) => TodoItemView(e)).toList(),
        ),
      );
    });
  }
}

class TodoItemView extends StatelessWidget {
  const TodoItemView(
    this.item, {
    super.key,
  });

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
          value: item.isCompleted,
          onChanged: (value) {
            context.read<TodoListBloc>().add(TodoListItemToggled(item, value!));
          }),
      title: Text(item.title,
          style: item.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null),
      trailing: InkWell(
          onTap: () {
            context.read<TodoListBloc>().add(TodoListItemDeleted(item));
          },
          child: const Icon(Icons.delete)),
    );
  }
}
