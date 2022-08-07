import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:photo_stream/amplifyconfiguration.dart';
import 'package:photo_stream/components/post_list.dart';
import 'package:photo_stream/state/app_state_model.dart';
import 'package:provider/provider.dart';

import '../models/ModelProvider.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({
    super.key,
  });

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  // subscription of Post QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Post>> _subscription;

  bool _isLoading = true;
  bool loadedPosts = false;
  List<Post?> _posts = [];

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();

    return result.isSignedIn;
  }

  void initializeScreen() async {
    bool didLoadFeed =
        Provider.of<AppStateModel>(context, listen: false).feedLoaded;
    bool datastoreReady =
        Provider.of<AppStateModel>(context, listen: false).datastoreReady;
    AmplifyConfig isConfigured = await Amplify.asyncConfig;

    if (isConfigured.api!.isNotEmpty && !didLoadFeed) {
      bool signedIn = await isUserSignedIn();

      print('my feed --> init load posts');
      print('datastore is READY');
      try {
        if (signedIn) {
          List<Post?> getPosts = await Amplify.DataStore.query(
            Post.classType,
          );
          setState(() {
            if (_isLoading) _isLoading = false;
            _posts = getPosts;
            loadedPosts = true;
            Provider.of<AppStateModel>(context, listen: false)
                .setFeedLoaded(true);
            Provider.of<AppStateModel>(context, listen: false)
                .setLoadedPosts(getPosts);
          });
        } else {
          GraphQLResponse<PaginatedResult<Post>> fetchData = await Amplify.API
              .query(request: ModelQueries.list(Post.classType))
              .response;
          if (fetchData.data != null) {
            List<Post?> getPosts = fetchData.data!.items;
            setState(() {
              if (_isLoading) _isLoading = false;
              _posts = getPosts;
              loadedPosts = true;
              Provider.of<AppStateModel>(context, listen: false)
                  .setFeedLoaded(true);
              Provider.of<AppStateModel>(context, listen: false)
                  .setLoadedPosts(getPosts);
            });
          }
        }
        // print(moredata.data!.items.toString());

      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, appState, child) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: appState.getLoadedPosts.isEmpty
              ? const CircularProgressIndicator()
              : PostList(posts: appState.getLoadedPosts),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
