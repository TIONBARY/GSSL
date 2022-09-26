import 'package:GSSL/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:geolocator/geolocator.dart';

import '../constants.dart';
import '../pages/walk_map.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar(
      {Key? key,
        required this.icon_color_com,
        required this.icon_color_home,
        required this.icon_color_loc,
      }) : super(key: key);

  final icon_color_com;
  final icon_color_home;
  final icon_color_loc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pColor,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.people_alt_outlined,
                size: 30,
                color: icon_color_com, // Color(0xFFFFF3E4),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30,
                color: icon_color_home, // btnColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.location_on_outlined,
                size: 30,
                color: icon_color_loc, // Color(0xFFFFF3E4),
              ),
              onPressed: () async {
                WidgetsFlutterBinding.ensureInitialized();
                Position pos = await Geolocator.getCurrentPosition();
                await dotenv.load(fileName: ".env");
                String kakaoMapKey = dotenv.get('kakaoMapAPIKey');

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KakaoMapTest(pos.latitude, pos.longitude, kakaoMapKey)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}