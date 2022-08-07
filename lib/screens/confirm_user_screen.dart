import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:photo_stream/screens/sign_up_screen.dart';

import '../models/ModelProvider.dart';

class ConfirmUserScreen extends StatefulWidget {
  const ConfirmUserScreen({super.key});

  @override
  _ConfirmUserScreenState createState() => _ConfirmUserScreenState();
}

class _ConfirmUserScreenState extends State<ConfirmUserScreen> {
  bool isSignUpComplete = false;
  TextEditingController confirmationCodeController = TextEditingController();

  Future<void> addUser(userId, username) async {
    final user = User(id: userId, username: username, Posts: [], Likes: []);
    await Amplify.DataStore.save(user);
  }

  Future<void> confirmUser(String username) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCodeController.text,
      );
      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        final id = user.userId;
        addUser(id, username);
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Widget displayConfirmState(String username, String password) {
    if (isSignUpComplete) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Account confirmed!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ElevatedButton(
            onPressed: () {
              signInUser(username, password);
              Navigator.pushNamed(context, '/profile');
            },
            child: const Text('Return to profile'),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Confirm Account',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Check your email for a confirmation code',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextField(
            controller: confirmationCodeController,
            decoration: InputDecoration(hintText: 'Confirmation'),
          ),
          ElevatedButton(
            onPressed: () => confirmUser(username),
            child: Text('Confirm'),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SignUpArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: displayConfirmState(args.username, args.password),
        ),
      ),
    );
  }
}
