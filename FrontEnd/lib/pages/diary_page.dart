import 'package:flutter/material.dart';


import 'package:GSSL/components/diary/diary_form.dart';
import 'package:GSSL/components/diary/walk_form.dart';

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Gallery'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: '일지', icon: Icon(Icons.book)),
                Tab(text: '산책', icon: Icon(Icons.directions_walk)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DiaryPage(),
              WalkPage(),
            ],
          ),
        ),
    );
  }
}


