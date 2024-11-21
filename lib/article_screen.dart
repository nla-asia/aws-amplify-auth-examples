import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:my_amplify_app/home_screen.dart';
import 'package:my_amplify_app/login_screen.dart';
import 'models/ModelProvider.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  List<Article> _articles = [];
  final authMode = APIAuthorizationType.userPools;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      ;
      if (session.isSignedIn) {
        _fetchArticles();
      } else {
        redirect();
      }
    } on AuthException catch (e) {
     // redirect();
      safePrint("You do not have permission to view this page actually.");
    }
  }

  void redirect() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _fetchArticles() async {
    try {
      final request =
          ModelQueries.list(Article.classType, authorizationMode: authMode);
      final response = await Amplify.API.query(request: request).response;

      final articles = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        _articles = articles!.whereType<Article>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  void addRandomArticle() async {
    final newArticle = Article(
      id: uuid(),
      title: "Article# ${DateTime.now().toIso8601String()}",
      content: "Random Article ${DateTime.now().toIso8601String()}",
    );
    final request =
        ModelMutations.create(newArticle, authorizationMode: authMode);
    final response = await Amplify.API.mutate(request: request).response;
    safePrint(response);
    if (response.hasErrors) {
      safePrint('Creating Article failed.');
    } else {
      _fetchArticles();
      safePrint('Creating Article successful.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(children: [
          Text('Articles (owner) '),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Random Article'),
        onPressed: () async {
          addRandomArticle();
        },
      ),
      body: _articles.isEmpty == true
          ? const Center(
              child: Text(
                "The list is empty.\nAdd some items by clicking the floating action button.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  child: CheckboxListTile.adaptive(
                    title: Text(article.content!),
                    onChanged: (isChecked) async {},
                    value: false,
                  ),
                );
              },
            ),
    );
  }
}
