import 'dart:async';
import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/response_models/token_reissue.dart';
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
        () async => await checkLoggedIn()
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ));
    assetAudioPlayer.open(Audio("assets/sounds/DogBark.wav"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/loading.gif'),
            fit: BoxFit.contain),
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    final storage = new FlutterSecureStorage();
    String url = "https://j7a204.p.ssafy.io/api/user/auth/reissue";
    try {
      String? refreshToken = await storage.read(key: 'RefreshToken');
      // 불러오기 성공
      // debugPrint(refreshToken);

      Response response = await client.post(Uri.parse(url),
          body: json.encode({'refreshToken': refreshToken}));

      tokenReissue reissueInfo =
          tokenReissue.fromJson(json.decode(response.body));
      debugPrint(response.body);

      String? newAcc = await reissueInfo.tokenInfo!.accessToken;
      String? newRef = await reissueInfo.tokenInfo!.refreshToken;
      if (newRef != null && newAcc != null) {
        // Write value
        await storage.write(key: 'Authorization', value: newAcc);
        await storage.write(key: 'RefreshToken', value: newRef);

        return response.statusCode == 200;
      } else {
        debugPrint("저장 실패");
        return false;
      }
      // // Write value
      // await storage.write(
      //     key: 'Authorization', value: reissueInfo.tokenInfo?.accessToken!);
      // await storage.write(
      //     key: 'RefreshToken', value: reissueInfo.tokenInfo?.refreshToken!);
      //
      // return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
