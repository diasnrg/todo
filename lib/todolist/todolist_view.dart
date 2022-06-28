import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/models/models.dart';
import 'package:todo/repository.dart';
import 'package:todo/todolist/bloc/todolist_bloc.dart';
import 'package:todo/todolist/create_item_view.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoListBloc(repository: context.read<TodoRepository>())
        ..add(TodoListInitializationRequested()),
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
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return const SliverToBoxAdapter(child: Text('error occured'));
        }
        if (state.status.isLoading) {
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        }

        final todos = state.todos;
        if (todos.isEmpty) {
          return SliverToBoxAdapter(
            child: Column(
              children: const [
                SizedBox(height: 64),
                Text('Todo list is empty =)'),
              ],
            ),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate(
            todos.map((e) => TodoItemView(e)).toList(),
          ),
        );
      },
    );
  }
}

class TodoItemView extends StatelessWidget {
  const TodoItemView(this.item, {super.key});

  final Todo item;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return ListTile(
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (value) {
          context.read<TodoListBloc>().add(
                TodoListItemToggled(item, value!),
              );
        },
      ),
      title: Text(
        item.title,
        style: textStyle?.copyWith(
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: InkWell(
        onTap: () =>
            context.read<TodoListBloc>().add(TodoListItemRemoved(item)),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 22,
        ),
      ),
    );
  }
}
