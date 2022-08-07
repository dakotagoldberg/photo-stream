import 'package:flutter/material.dart';
import 'package:photo_stream/navigation/feed_navigator.dart';
import 'package:photo_stream/screens/new_post_screen.dart';
import 'package:photo_stream/screens/post_details_screen.dart';
import 'package:photo_stream/screens/profile_screen.dart';

import '../models/ModelProvider.dart';
import '../screens/my_feed_screen.dart';

class BottomTabs extends StatefulWidget {
  final int index;
  final int feedIndex;
  const BottomTabs({
    super.key,
    required this.index,
    this.feedIndex = 0,
  });

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    FeedNavigator(index: 0),
    const NewPostScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.index;
      _widgetOptions = <Widget>[
        FeedNavigator(index: widget.feedIndex),
        const NewPostScreen(),
        const ProfileScreen(),
      ];
    });
  }

  static const List<Widget> _titleOptions = <Widget>[
    Text('My Feed'),
    Text('New Post'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _titleOptions.elementAt(_selectedIndex),
          automaticallyImplyLeading: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_rounded),
              label: "Post",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
