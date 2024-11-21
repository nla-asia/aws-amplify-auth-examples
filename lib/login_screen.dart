import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_amplify_app/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {

    return Authenticator(
      child: Authenticator.builder()(
        context,
        Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are loggedin now!'),
                  SizedBox(height:10),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>const HomeScreen()));
                  }, child: Text('Go to Home')
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      Amplify.Auth.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}