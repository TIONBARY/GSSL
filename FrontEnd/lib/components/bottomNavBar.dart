import 'dart:convert';

import 'package:GSSL/pages/community_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:GSSL/pages/user_info_page.dart';
import 'package:GSSL/pages/walk_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    CommunityApp(),
    KakaoMapTest(),
    UserInfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: pColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Community',
            backgroundColor: pColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Walk',
            backgroundColor: pColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'UserInfo',
            backgroundColor: pColor,
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: btnColor,
        unselectedItemColor: sColor,
        iconSize: 30,
        backgroundColor: pColor,
        // type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// class bottomNavBar extends StatelessWidget {
//
//   const bottomNavBar(
//       {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: pColor,
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             CircleAvatar(
//               backgroundColor: back_com,
//               radius: 20,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(
//                   Icons.people_alt_outlined,
//                   size: 30,
//                   color: icon_color_com, // Color(0xFFFFF3E4),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => CommunityApp()),
//                   );
//                 },
//               ),
//             ),
//             CircleAvatar(
//               backgroundColor: back_home,
//               radius: 20,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(
//                   Icons.home_outlined,
//                   size: 30,
//                   color: icon_color_home, // btnColor,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MainPage()),
//                   );
//                 },
//               ),
//             ),
//             CircleAvatar(
//               backgroundColor: back_loc,
//               radius: 20,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(
//                   Icons.location_on_outlined,
//                   size: 30,
//                   color: icon_color_loc, // Color(0xFFFFF3E4),
//                 ),
//                 onPressed: () async {
//                   WidgetsFlutterBinding.ensureInitialized();
//                   Position pos = await Geolocator.getCurrentPosition();
//                   await dotenv.load(fileName: ".env");
//                   String kakaoMapKey = dotenv.get('kakaoMapAPIKey');
//
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => KakaoMapTest(pos.latitude, pos.longitude, kakaoMapKey)),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
