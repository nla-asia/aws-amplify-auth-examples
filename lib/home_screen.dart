import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_amplify_app/article_screen.dart';
import 'package:my_amplify_app/learningpath_screen.dart';
import 'package:my_amplify_app/login_screen.dart';
import 'package:my_amplify_app/product_screen.dart';
import 'package:my_amplify_app/todo_screen.dart';
import 'package:my_amplify_app/topic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    final session = await Amplify.Auth.fetchAuthSession(
        // options: FetchAuthSessionOptions(forceRefresh: true)
        );
    if (session.isSignedIn) {
      print('User is signed in');
    } else {
      print('User is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())
                );
              },
              child: Text('Login')
            ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodoScreen()));
              },
              child: Text('See Todos (Guests)')),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TopicScreen()));
              },
              child: Text('See Topics (Authenticated)')),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ArticleScreen()));
              },
              child: Text('See Articles (Owners)')),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductScreen()));
              },
              child: Text('See Products (Guests, Authenticated)')),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LearningPathScreen()));
              },
              child:
                  Text('See Learning Paths (Guests, Authenticated, Owners)')),
        ],
      ),
    );
  }
}
