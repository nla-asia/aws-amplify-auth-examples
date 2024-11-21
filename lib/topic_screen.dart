import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:my_amplify_app/home_screen.dart';
import 'models/ModelProvider.dart';
import 'models/Topic.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Topic> _topics = [];
  APIAuthorizationType authMode = APIAuthorizationType.userPools;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session.isSignedIn) {
      _fetchTopics();
      
    } else {
      // this page is for any loggedin users
      safePrint("If you are not loggedin, you cannot use this page.");
      // redirect();
    }
  }

  void redirect() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<void> _fetchTopics() async {
    try {
      final request =
          ModelQueries.list(Topic.classType, authorizationMode: authMode);
      final response = await Amplify.API.query(request: request).response;

      final Topics = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        _topics = Topics!.whereType<Topic>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  void addRandomTopic() async {
    final newTopic = Topic(
      id: uuid(),
      title: "Random Topic ${DateTime.now().toIso8601String()}",
    );
    final request =
        ModelMutations.create(newTopic, authorizationMode: authMode);
    final response = await Amplify.API.mutate(request: request).response;
    if (response.hasErrors) {
      safePrint('Creating Topic failed.');
    } else {
      safePrint('Creating Topic successful.');
      _fetchTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Topics (authenticated)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Random Topic'),
        onPressed: () async {
          addRandomTopic();
        },
      ),
      body: _topics.isEmpty == true
          ? const Center(
              child: Text(
                "The list is empty.\nAdd some items by clicking the floating action button.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final Topic = _topics[index];
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  child: CheckboxListTile.adaptive(
                    title: Text(Topic.title!),
                    onChanged: (isChecked) async {},
                    value: false,
                  ),
                );
              },
            ),
    );
  }
}
