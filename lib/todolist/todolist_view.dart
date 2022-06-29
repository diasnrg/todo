import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo/models/models.dart';
import 'package:todo/todolist/bloc/todolist_bloc.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TodoListView(),
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
          return const Text('error occured');
        }
        if (state.status.isLoading) {
          return const CircularProgressIndicator();
        }

        final todolist = state.todolist;
        if (todolist.isEmpty) {
          return Column(
            children: const [
              SizedBox(height: 64),
              Center(child: Text('Todo list is empty =)')),
            ],
          );
        }

        final completed = todolist.where((e) => e.isCompleted).toList();
        final uncompleted = todolist.where((e) => !e.isCompleted).toList();

        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                  uncompleted.map((e) => TodoItemView(e)).toList()),
            ),
            if (uncompleted.isNotEmpty)
              const SliverToBoxAdapter(
                child: Divider(
                  height: 1,
                  thickness: 1,
                ),
              ),
            SliverToBoxAdapter(
              child: ListTile(
                title: Text(
                  'Completed (${completed.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => context
                    .read<TodoListBloc>()
                    .add(TodoListCompletedItemsVisibilityChanged()),
                trailing: Icon(
                  state.isHiddenCompletedItems
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ),
              ),
            ),
            if (state.isHiddenCompletedItems == false)
              SliverList(
                delegate: SliverChildListDelegate(
                    completed.map((e) => TodoItemView(e)).toList()),
              ),
            if (uncompleted.isEmpty)
              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    SizedBox(height: 128),
                    Text('All tasks completed'),
                  ],
                ),
              ),
          ],
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
        onChanged: (_) {
          context.read<TodoListBloc>().add(TodoListItemToggled(item));
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
