import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

const String kakaoMapKey = 'kakao자바스크립트API';

void main() {
  runApp(MaterialApp(home: KakaoMapTest()));
}

/// Determine the current position of the device.
/// 디바이스의 현재 위치 결정
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
/// 위치 서비스가 활성화 되어있지 않거나 권한이 없는 경우 `Future` 에러
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('위치 서비스 비활성화');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('위치 정보 권한이 없음');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        '위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class KakaoMapTest extends StatefulWidget {
  @override
  State<KakaoMapTest> createState() => _KakaoMapTestState();
}

class _KakaoMapTestState extends State<KakaoMapTest> {
  late WebViewController _mapController;
  final double _lat = 37.5013068;
  final double _lng = 127.0396597;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('카카오 맵(산책 경로 예정)')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
            width: size.width,
            // height: size.height * 7 / 10,
            height: size.height - appBarHeight - 80,
            // height: size.height,
            // height: size.height - 40,
            kakaoMapKey: kakaoMapKey,
            lat: _lat,
            lng: _lng,
            showMapTypeControl: false,
            showZoomControl: false,
            draggableMarker: false,
            // mapType: MapType.TERRAIN,
            mapController: (controller) {
              _mapController = controller;
            },
            polyline: KakaoFigure(
              path: [
                KakaoLatLng(lat: 37.5013068, lng: 127.0396597),
                KakaoLatLng(lat: 37.5113068, lng: 127.03917),
                KakaoLatLng(lat: 37.5213068, lng: 127.03869),
                KakaoLatLng(lat: 37.5313068, lng: 127.03971)
              ],
              strokeColor: Colors.blue,
              strokeWeight: 2.5,
              strokeColorOpacity: 0.9,
            ),
            zoomChanged: (message) {
              debugPrint('[확대] ${message.message}');
            },
            cameraIdle: (message) {
              KakaoLatLng latLng =
              KakaoLatLng.fromJson(jsonDecode(message.message));
              debugPrint('[대기중] ${latLng.lat}, ${latLng.lng}');
            },
            boundaryUpdate: (message) {
              KakaoBoundary boundary =
              KakaoBoundary.fromJson(jsonDecode(message.message));
              debugPrint(
                  '[범위] ne : ${boundary.neLat}, ${boundary.neLng}, sw : ${boundary.swLat}, ${boundary.swLng}');
            },
          ),
          ElevatedButton(
              child: Text('산책 시작'),
              onPressed: () async {
                // await _openKakaoMapScreen(context);
                // 1번 기록(최초 위치)
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                // 연속적인 위치 정보 기록
                final LocationSettings locationSettings = LocationSettings(
                  accuracy: LocationAccuracy.high,
                  distanceFilter: 100,
                );
                Position currentPosition;

                StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
                        (Position? position) {
                      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
                    });

                var lat = position.latitude, // 위도
                    lon = position.longitude; // 경도
                debugPrint('[버튼 클릭]');
                debugPrint('$position');
                debugPrint(lat.toString());
                debugPrint(lon.toString());

                _mapController.runJavascript('''
                  if ('$position') {
                  // GeoLocation을 이용해서 접속 위치를 얻어옵니다
                  
                    // alert('$lat');
                    // alert('$lon');
                    var lat = parseFloat('$lat'), // 위도
                        lon = parseFloat('$lon'); // 경도
        
                    // alert(lat);
                    // alert(lon);
                    var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
                        message = '<div style="padding:5px;">여기에 계신가요?!</div>'; // 인포윈도우에 표시될 내용입니다
                    
                    // 마커와 인포윈도우를 표시합니다
                    displayMarker(locPosition, message);
                      
                  } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
                      
                      var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
                          message = 'geolocation을 사용할수 없어요..'
                          
                      displayMarker(locPosition, message);
                  }
                
                // 지도에 마커와 인포윈도우를 표시하는 함수입니다
                function displayMarker(locPosition, message) {
                
                    // 마커를 생성합니다
                    var marker = new kakao.maps.Marker({  
                        map: map, 
                        position: locPosition
                    }); 
                    
                    var iwContent = message, // 인포윈도우에 표시할 내용
                        iwRemoveable = true;
                
                    // 인포윈도우를 생성합니다
                    var infowindow = new kakao.maps.InfoWindow({
                        content : iwContent,
                        removable : iwRemoveable
                    });
                    
                    // 인포윈도우를 마커위에 표시합니다 
                    infowindow.open(map, marker);
                    
                    // 지도 중심좌표를 접속위치로 변경합니다
                    map.setCenter(locPosition);      
                }
            ''');
              })
        ],
      ),
    );
  }
}
