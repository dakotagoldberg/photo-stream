import 'package:flutter/material.dart';
import 'package:photo_stream/screens/my_feed_screen.dart';
import 'package:photo_stream/screens/post_details_screen.dart';

class FeedNavigator extends StatelessWidget {
  FeedNavigator({super.key, required this.index});

  final int index;

  final List<Widget> screens = [
    const MyFeedScreen(),
    PostDetailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return screens.elementAt(index);
  }
}
