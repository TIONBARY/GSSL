import 'dart:convert';

import 'package:GSSL/pages/community_page.dart';
import 'package:GSSL/pages/main_page.dart';
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
  int _selectedIndex = 1;

  List<Widget> _widgetOptions = <Widget>[
    CommunityApp(),
    MainPage(),
    FutureBuilder(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
          if (snapshot.hasData == false) {
            return CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
          }

          //error가 발생하게 될 경우 반환하게 되는 부분
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                style: TextStyle(fontSize: 15),
              ),
            );
          }

          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
          else {
            debugPrint(snapshot.data);
            Map<String, dynamic> jsonData = jsonDecode(snapshot.data);
            KakaomapInfo info = KakaomapInfo.fromJson(jsonData);
            return Padding(
              padding: const EdgeInsets.all(0.0),
              // child: Text(snapshot.data),
              child: KakaoMapTest(info.lat!, info.lon!, info.kakaoMapKey!),
              // child: KakaoMapTest(snapshot.data.pos.latitude,
              //     snapshot.data.pos.longitude, snapshot.data.kakaoMapKey),
              // Text(
              //   snapshot.data.toString(), // 비동기 처리를 통해 받은 데이터를 텍스트에 뿌려줌
              //   style: TextStyle(fontSize: 15),
              // ),
            );
          }
        }),
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
            icon: Icon(Icons.people_alt_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            label: 'Walk',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: btnColor,
        iconSize: 30,
        unselectedItemColor: sColor,
        backgroundColor: pColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 비동기 처리
Future _future() async {
  WidgetsFlutterBinding.ensureInitialized();
  Position pos = await Geolocator.getCurrentPosition();
  await dotenv.load(fileName: ".env");
  String kakaoMapKey = dotenv.get('kakaoMapAPIKey');
  debugPrint("어싱크 내부");
  String kakaomapInfo = jsonEncode(KakaomapInfo(
      kakaoMapKey: kakaoMapKey, lat: pos.latitude, lon: pos.longitude));
  debugPrint(kakaomapInfo);
  return kakaomapInfo; // 5초 후 '짜잔!' 리턴
}

class KakaomapInfo {
  String? kakaoMapKey;
  double? lat;
  double? lon;

  KakaomapInfo({
    this.kakaoMapKey,
    this.lat,
    this.lon,
  });

  KakaomapInfo.fromJson(Map<String, dynamic> json) {
    kakaoMapKey = json['kakaoMapKey'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    return {
      'kakaoMapKey': kakaoMapKey,
      'lat': lat,
      'lon': lon,
    };
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
