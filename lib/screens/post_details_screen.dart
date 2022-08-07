import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_stream/components/like_button.dart';
import 'package:photo_stream/components/like_button_with_count.dart';
import 'package:photo_stream/components/post_tile.dart';
import 'package:provider/provider.dart';

import '../models/ModelProvider.dart';
import '../state/app_state_model.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  Future<String> getUsernameFromId(userId) async {
    bool signedIn = await isUserSignedIn();
    if (signedIn) {
      final users = await Amplify.DataStore.query(User.classType,
          where: User.ID.eq(userId));
      return users.isNotEmpty ? users.first.username : '';
    } else {
      final user = (await Amplify.API
          .query(request: ModelQueries.get(User.classType, userId))
          .response);
      return user.data != null ? user.data!.username : '';
    }
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();

    return result.isSignedIn;
  }

  Future<String> getCurrentUserId() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  Future<bool> isCurrentUserPost(Post post) async {
    final currentUserId = await getCurrentUserId();
    if (post.userID == currentUserId) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deletePost(Post post) async {
    Post postToDelete = post;
    await Amplify.DataStore.delete(postToDelete);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PostArguments;

    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            'https://photostream8d1db34174934c069ce8b0714094f596141605-staging.s3.amazonaws.com/public/${args.post.image}',
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: Text(
                        args.post.title,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: getUsernameFromId(args.post.userID),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            '@${snapshot.data.toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          return Text(
                            '@user',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
            LikeButtonWithCount(post: args.post),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 4.0),
          child: Text(
            args.post.createdAt != null
                ? DateFormat.yMd()
                    .add_jm()
                    .format(DateTime.parse(args.post.createdAt.toString()))
                : 'No post date found',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black54),
          ),
        ),
        Text(
          args.post.description ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: FutureBuilder(
            future: isCurrentUserPost(args.post),
            builder: ((context, snapshot) {
              if (snapshot.data == true) {
                return TextButton(
                  onPressed: () {
                    deletePost(args.post);
                    Provider.of<AppStateModel>(context, listen: false)
                        .setFeedLoaded(false);
                    Navigator.pushNamed(context, '/');
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete Post'),
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
        ),
      ],
    );
  }
}
