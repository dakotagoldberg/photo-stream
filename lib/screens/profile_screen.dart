import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:photo_stream/screens/log_in_screen.dart';
import 'package:photo_stream/screens/sign_up_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    setState(() {
      isSignedIn = result.isSignedIn;
    });
    return result.isSignedIn;
  }

  Future<String> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.username;
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
      final result = await Amplify.Auth.fetchAuthSession();
      setState(() {
        isSignedIn = result.isSignedIn;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Widget userMessage() {
    /*
      I think I need to make it so it determines if the user
      is signed in (with some state variable) and then changes
      the user message based on that?
    */
    return FutureBuilder(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            '@${snapshot.data}',
            style: Theme.of(context).textTheme.titleLarge,
          );
        } else {
          return const Text('Log in to view your profile!');
        }
      },
    );
  }

  Widget authButton() {
    return FutureBuilder(
      future: isUserSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return ElevatedButton(
            onPressed: () {
              signOutCurrentUser();
              Amplify.DataStore.clear();
            },
            child: const Text('Sign Out'),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LogInScreen(),
                  ));
                },
                child: const Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ));
                },
                child: const Text('Sign Up'),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        userMessage(),
        authButton(),
      ],
    );
  }
}
