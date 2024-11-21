import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'models/ModelProvider.dart';
import 'models/LearningPath.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  List<LearningPath> _learningPaths = [];
  APIAuthorizationType authMode = APIAuthorizationType.iam;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    final session = await Amplify.Auth.fetchAuthSession();
    setState(() {
      authMode = session.isSignedIn
          ? APIAuthorizationType.userPools
          : APIAuthorizationType.iam;
    });
    _fetchLearningPaths();
  }

  Future<void> _fetchLearningPaths() async {
    try {
      final request = ModelQueries.list(LearningPath.classType, authorizationMode: authMode);
      final response = await Amplify.API.query(request: request).response;

      final LearningPaths = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        _learningPaths = LearningPaths!.whereType<LearningPath>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  void addRandomLearningPath() async {
      final newLearningPath = LearningPath(
            id: uuid(),
            name: "Random LearningPath ${DateTime.now().toIso8601String()}",
          );
          final request = ModelMutations.create(newLearningPath, authorizationMode: authMode);
          final response = await Amplify.API.mutate(request: request).response;
          if (response.hasErrors) {
            safePrint('Creating LearningPath failed.');
          } else {
            safePrint('Creating LearningPath successful.');
            _fetchLearningPaths();
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LearningPaths (guest, authenticated)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Random LearningPath'),
        onPressed: () async {
          addRandomLearningPath();
        },
      ),
      body: _learningPaths.isEmpty == true
          ? const Center(
              child: Text(
                "The list is empty.\nAdd some items by clicking the floating action button.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _learningPaths.length,
              itemBuilder: (context, index) {
                final LearningPath = _learningPaths[index];
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  child: CheckboxListTile.adaptive(
                    title: Text(LearningPath.name!),
                    onChanged: (isChecked) async {},
                    value: false,
                  ),
                );
              },
            ),
    );
  }
}
