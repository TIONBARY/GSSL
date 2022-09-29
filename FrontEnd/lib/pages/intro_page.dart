import 'dart:async';
import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/request_models/put_login_refresh.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

/***
 * Container(
    width: double.infinity,
    height: double.infinity,
    child:Image.asset('assets/images/loading.png'),
    );
 */

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final assetAudioPlayer = AssetsAudioPlayer();
  final storage = new FlutterSecureStorage();
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () async => await checkLoggedIn() == false
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              ));
    assetAudioPlayer.open(Audio("assets/sounds/DogBark.wav"));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/loading.gif'),
            fit: BoxFit.contain),
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    String? refreshToken = null;
    refreshToken = await storage.read(key: 'RefreshToken');
    if (refreshToken != null) {
      String url = "https://j7a204.p.ssafy.io/api/user/auth/reissue";
      Response response = await client.post(Uri.parse(url),
          body: jsonEncode(
              RefreshTokenRequestModel(refreshToken: refreshToken).toJson()));
      debugPrint(response.statusCode.toString());
      return response.statusCode == 200;
    }
    return false;
  }
}
