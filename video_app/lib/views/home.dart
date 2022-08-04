import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'uploadVideo.dart';
import 'profile.dart';
import 'search.dart';
import 'video.dart';
import '../controllers/auth.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int index = 0;

  List views = [
    Video(),
    Search(),
    AddVideo(),
    Profile(isSearch: false, uid: AuthController.instance.user.uid),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          backgroundColor: Colors.pink[100],
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.camera,
                size: 30,
              ),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile',
            ),
          ],
        ),
        body: views[index]);
  }
}
