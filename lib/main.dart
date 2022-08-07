import 'dart:async';

import 'package:flutter/material.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:photo_stream/navigation/bottom_tabs.dart';
import 'package:photo_stream/screens/post_details_screen.dart';
import 'package:photo_stream/state/app_state_model.dart';
import 'package:provider/provider.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppStateModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  bool _isLoading = true;
  StreamSubscription<HubEvent>? stream;
  StreamSubscription<HubEvent>? authStream;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  // Future<void> _initializeApp() async {
  //   await _configureAmplify();
  // }

  Future<void> _configureAmplify() async {
    final AmplifyAuthCognito auth = AmplifyAuthCognito();
    final AmplifyDataStore datastore = AmplifyDataStore(
        modelProvider: ModelProvider.instance,
        authModeStrategy: AuthModeStrategy.multiAuth);
    final storage = AmplifyStorageS3();
    final AmplifyAPI api = AmplifyAPI(
      modelProvider: ModelProvider.instance,
    );

    await Amplify.addPlugins([auth, datastore, api, storage]);

    try {
      await Amplify.configure(amplifyconfig);
      await Amplify.DataStore.start();
      print('configuring');
      setState(() {
        _amplifyConfigured = true;
        stream = Amplify.Hub.listen([HubChannel.DataStore], (hubEvent) async {
          print(hubEvent.eventName);
          if (hubEvent.eventName == 'ready') {
            Provider.of<AppStateModel>(context, listen: false)
                .setDatastoreReady(true);
            // List<Post> getPosts = await Amplify.DataStore.query(
            //   Post.classType,
            // );
            // print(getPosts);
            // await Amplify.DataStore.clear();
          }
        });
        print('between listens');
        authStream = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
          print('Auth: ${hubEvent.eventName}');
        });
      });
    } on AmplifyAlreadyConfiguredException {
      print(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    } on Exception catch (e) {
      print('An error occured configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Share',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BottomTabs(index: 0),
        '/post': (context) => const BottomTabs(index: 1),
        '/profile': (context) => const BottomTabs(index: 2),
        '/details': (context) => const BottomTabs(
              index: 0,
              feedIndex: 1,
            ),
      },
    );
  }
}
