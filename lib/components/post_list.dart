import 'package:flutter/material.dart';
import 'package:photo_stream/components/post_tile.dart';

import '../models/ModelProvider.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
  });

  final List<Post?> posts;

  List<Post?> sortPosts(List<Post?> postList) {
    postList.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
    return postList;
  }

  Widget buildFeed() {
    if (posts.isNotEmpty) {
      return ListView(
        children: sortPosts(posts).map((post) {
          return PostTile(post: post as Post);
        }).toList(),
      );
    } else {
      return const Text("Nobody's posted anything.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildFeed();
  }
}
