import 'package:flutter/material.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:photo_stream/screens/confirm_user_screen.dart';

class SignUpArguments {
  final String username;
  final String password;
  SignUpArguments(this.username, this.password);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSignUpComplete = false;
  String username = '';
  String password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUpUser() async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: emailController.text,
      };
      if (passwordController.text == confirmPasswordController.text) {
        final result = await Amplify.Auth.signUp(
          username: usernameController.text,
          password: passwordController.text,
          options: CognitoSignUpOptions(userAttributes: userAttributes),
        );
        setState(() {
          isSignUpComplete =
              result.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP';
          username = usernameController.text;
          password = passwordController.text;
        });
      } else {
        const AlertDialog(
          title: Text('Your passwords do not match!'),
          content: Text('Please re-enter your passwords.'),
        );
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Widget displayConfirmOption() {
    if (!isSignUpComplete) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'Username'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(onPressed: signUpUser, child: const Text('Sign Up'))
        ],
      );
    } else {
      return ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const ConfirmUserScreen(),
                  settings: RouteSettings(
                      arguments: SignUpArguments(username, password))),
            );
          },
          child: const Text('Confirm Email'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: displayConfirmOption(),
          ),
        ));
  }
}
