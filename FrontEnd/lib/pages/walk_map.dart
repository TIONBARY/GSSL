import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kakaoMapKey = 'kakao자바스크립트API';
List<Position> positionList = [];
List<KakaoLatLng> kakaoPositionList = [];

void main() async {
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

  // 백그라운드 GPS 권한 요청
  PermissionStatus alwaysPermission = await Permission.locationAlways.status;
  if (alwaysPermission == PermissionStatus.granted) {
    return await Geolocator.getCurrentPosition();
  } else if (alwaysPermission == PermissionStatus.permanentlyDenied) {
    return Future.error('위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  } else {
    Permission.locationAlways.request();
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

void startWalk(Position position, _mapController) {
  // 연속적인 위치 정보 기록에 사용될 설정
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  StreamSubscription<Position> positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
    if (!positionList.contains(position)) {
      if (positionList.length > 0) {
        drawLine(_mapController, position, positionList.last);
      }
      positionList.add(position!);
    }
  });

  var lat = position.latitude, // 위도
      lon = position.longitude; // 경도
  debugPrint('[버튼 클릭]');
  debugPrint('$position');
  debugPrint(lat.toString());
  debugPrint(lon.toString());

  if (positionList.length == 0) {
    _mapController.runJavascript('''
                  if ('$position') {
                  // GeoLocator을 이용해서 얻어온 접속 위치로 이동합니다
                    var lat = parseFloat('$lat'), // 위도
                        lon = parseFloat('$lon'); // 경도
                    var locPosition = new kakao.maps.LatLng(lat, lon);
                    map.setCenter(locPosition);
                      
                  } else { // 위치정보를 사용할 수 없을때 이동할 위치를 설정합니다
                  
                    var locPosition = new kakao.maps.LatLng(37.5013068, 127.0396597); // 멀티캠퍼스 위치
                    map.setCenter(locPosition);
                  }
            ''');
  }
}

void drawLine(_mapController, position, beforePos) {
  var lat = 0.0, lon = 0.0;
  var beforeLat = 0.0, beforeLon = 0.0;

  lat = position.latitude;
  lon = position.longitude;
  beforeLat = beforePos.latitude;
  beforeLon = beforePos.longitude;
  kakaoPositionList
      .add(KakaoLatLng(lat: position.latitude, lng: position.longitude));
  debugPrint('그리는 중');
  _mapController.runJavascript('''
                    var lat = parseFloat('$lat'), // 위도
                        lon = parseFloat('$lon'); // 경도
                    var beforeLat = parseFloat('$beforeLat'), // 위도
                        beforeLon = parseFloat('$beforeLon'); // 경도
  var locPosition = new kakao.maps.LatLng(lat, lon);
  var beforeLocPosition = new kakao.maps.LatLng(beforeLat, beforeLon);
  var linePath = [];
  map.setCenter(locPosition);
  linePath.push(beforeLocPosition);
  linePath.push(locPosition);

// 지도에 표시할 선을 생성합니다
var polyline = new kakao.maps.Polyline({
    path: linePath, // 선을 구성하는 좌표배열 입니다
    strokeWeight: 5, // 선의 두께 입니다
    strokeColor: '#FFAE00', // 선의 색깔입니다
    strokeOpacity: 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
    strokeStyle: 'solid' // 선의 스타일입니다
});

// 지도에 선을 표시합니다 
polyline.setMap(map);
            ''');
}

void stopWalk() {
  debugPrint('산책 끝');
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
    Position position = Position(
        longitude: 127.0396597,
        latitude: 37.5013068,
        timestamp: DateTime(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);

    Future<Position> future = _determinePosition();
    future.then((pos) => position = pos);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('카카오 맵(산책 경로 예정)')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
            width: size.width,
            // height: size.height * 7 / 10,
            height: size.height - appBarHeight - 130,
            // height: size.height - 40,
            kakaoMapKey: kakaoMapKey,
            lat: position.latitude,
            lng: position.longitude,
            showMapTypeControl: false,
            showZoomControl: false,
            draggableMarker: false,
            // mapType: MapType.TERRAIN,
            mapController: (controller) {
              _mapController = controller;
            },
            polyline: KakaoFigure(path: []),
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
                // 1번 기록(최초 위치)
                Future<Position> future = _determinePosition();
                future
                    .then((pos) => startWalk(pos, _mapController))
                    .catchError((error) => debugPrint(error));
              }),
          ElevatedButton(
              child: Text('산책 종료'),
              onPressed: () async {
                stopWalk();
              })
        ],
      ),
    );
  }
}
