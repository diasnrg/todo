import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/repository.dart';
import 'package:todo/theme/theme_cubit.dart';
import 'package:todo/theme/theme_data.dart';
import 'package:todo/todolist/todolist_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository =
      TodoRepository(storage: await SharedPreferences.getInstance());
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: App(repository: repository),
    ),
  );
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
      theme: TodoThemeData.lightTheme,
      darkTheme: TodoThemeData.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo'),
          actions: _themeSwitcher(context.read<ThemeCubit>()),
        ),
        body: RepositoryProvider.value(
          value: repository,
          child: const TodoListPage(),
        ),
      ),
      themeMode: context.watch<ThemeCubit>().state,
    );
  }

  List<Widget> _themeSwitcher(ThemeCubit themeMode) {
    return [
      Checkbox(
        value: themeMode.state == ThemeMode.dark,
        onChanged: (_) => themeMode.toggleThemeMode(),
      ),
      const Center(child: Text('dark mode')),
      const SizedBox(width: 16),
    ];
  }
}
