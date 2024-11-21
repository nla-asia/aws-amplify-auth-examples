import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:my_amplify_app/home_screen.dart';
import 'models/ModelProvider.dart';
import 'models/Todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> _todos = [];
  APIAuthorizationType authMode = APIAuthorizationType.iam;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void redirect() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void checkSession() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session.isSignedIn) {
      // this page is not for loggedin users
      safePrint("If you are loggedin, you cannot use this page.");
      // redirect();
    } else {
      _fetchTodos();
    }
  }

  Future<void> _fetchTodos() async {
    try {
      final request =
          ModelQueries.list(Todo.classType, authorizationMode: authMode);
      final response = await Amplify.API.query(request: request).response;

      final todos = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        _todos = todos!.whereType<Todo>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  void addRandomTodo() async {
    final newTodo = Todo(
      id: uuid(),
      content: "Random Todo ${DateTime.now().toIso8601String()}",
    );
    final request = ModelMutations.create(newTodo, authorizationMode: authMode);
    final response = await Amplify.API.mutate(request: request).response;
    if (response.hasErrors) {
      safePrint('Creating Todo failed.');
    } else {
      safePrint('Creating Todo successful.');
      _fetchTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos (guest)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Random Todo'),
        onPressed: () async {
          addRandomTodo();
        },
      ),
      body: _todos.isEmpty == true
          ? const Center(
              child: Text(
                "The list is empty.\nAdd some items by clicking the floating action button.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  child: CheckboxListTile.adaptive(
                    title: Text(todo.content!),
                    onChanged: (isChecked) async {},
                    value: false,
                  ),
                );
              },
            ),
    );
  }
}
