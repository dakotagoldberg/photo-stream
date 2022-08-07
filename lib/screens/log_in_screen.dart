import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isSignedIn = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInUser() async {
    try {
      final result = await Amplify.Auth.signIn(
        username: usernameController.text,
        password: passwordController.text,
      );
      setState(() {
        isSignedIn = result.isSignedIn;
      });
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      if (isSignedIn) {
        Navigator.pushNamed(context, '/profile');
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Log In',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () {
                    signInUser();
                  },
                  child: const Text('Log In'))
            ],
          ),
        ),
      ),
    );
  }
}
