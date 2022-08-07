import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:photo_stream/models/ModelProvider.dart';

class LikeButtonWithCount extends StatefulWidget {
  const LikeButtonWithCount({super.key, required this.post});

  final Post post;

  @override
  _LikeButtonWithCountState createState() => _LikeButtonWithCountState();
}

class _LikeButtonWithCountState extends State<LikeButtonWithCount> {
  late Post _post;
  bool _likedPost = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _post = widget.post;
    });
  }

  Future<String> getCurrentUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      return user.userId;
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  Future<User> getCurrentUser() async {
    String currentUserId = await getCurrentUserId();
    final userWithId = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(currentUserId),
    );
    return userWithId.first;
  }

  Future<bool> didUserLikePost() async {
    final User currentUser = await getCurrentUser();
    final getLikes = await Amplify.DataStore.query(
      UserLikes.classType,
      where: UserLikes.USER.eq(currentUser.id).and(UserLikes.POST.eq(_post.id)),
    );
    // print(getLikes.length);
    setState(() {
      _likedPost = getLikes.isNotEmpty;
    });
    return getLikes.isNotEmpty;
  }

  Future<int> numberOfLikes() async {
    final getLikes = await Amplify.DataStore.query(UserLikes.classType,
        where: UserLikes.POST.eq(_post.id));
    return getLikes.length;
  }

  Future<void> likePost() async {
    try {
      final User currentUser = await getCurrentUser();
      final userLike = UserLikes(user: currentUser, post: _post);
      await Amplify.DataStore.save(userLike);
      setState(() {
        _likedPost = true;
      });
    } catch (e) {
      print('Error: $e');
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> unlikePost() async {
    try {
      final User currentUser = await getCurrentUser();

      final getLikes = await Amplify.DataStore.query(
        UserLikes.classType,
        where:
            UserLikes.USER.eq(currentUser.id).and(UserLikes.POST.eq(_post.id)),
      );
      await Amplify.DataStore.delete(getLikes.first);
      setState(() {
        _likedPost = false;
      });
    } catch (e) {
      print('Error: $e');
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: didUserLikePost(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Row(
            children: [
              FutureBuilder(
                future: numberOfLikes(),
                builder: ((context, snapshot) {
                  return Text(
                    snapshot.hasData ? snapshot.data.toString() : "0",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  );
                }),
              ),
              IconButton(
                onPressed: unlikePost,
                icon: const Icon(
                  Icons.favorite_rounded,
                  size: 28,
                  color: Colors.red,
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              FutureBuilder(
                future: numberOfLikes(),
                builder: ((context, snapshot) {
                  return Text(
                    snapshot.hasData ? snapshot.data.toString() : "0",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  );
                }),
              ),
              IconButton(
                onPressed: likePost,
                icon: const Icon(
                  Icons.favorite_outline_rounded,
                  size: 28,
                  color: Colors.red,
                ),
              )
            ],
          );
        }
      },
    );
  }
}
