import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_stream/components/like_button.dart';

import '../models/ModelProvider.dart';

class PostArguments {
  Post post;
  PostArguments(this.post);
}

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: PostArguments(post),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://photostream8d1db34174934c069ce8b0714094f596141605-staging.s3.amazonaws.com/public/${post.image}',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        post.createdAt != null
                            ? DateFormat.yMd().add_jm().format(
                                DateTime.parse(post.createdAt.toString()))
                            : 'No post date found',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                LikeButton(post: post),
              ],
            )
          ],
        ),
      ),
    );
  }
}
