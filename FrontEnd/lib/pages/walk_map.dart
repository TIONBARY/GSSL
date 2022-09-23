import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
// const String kakaoMapKey = 'kakao자바스크립트API';

List<Position> positionList = [];
StreamSubscription<Position>? _positionStreamSubscription;
int totalWalkLength = 0;
var bounds = new KakaoBoundary();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Position pos = await _determinePosition();
  await dotenv.load(fileName: ".env");
  String kakaoMapKey = dotenv.get('kakaoMapAPIKey');

  runApp(MaterialApp(home: KakaoMapTest(pos.latitude, pos.longitude, kakaoMapKey)));
}

/// 디바이스의 현재 위치 결정
/// 위치 서비스가 활성화 되어있지 않거나 권한이 없는 경우 `Future` 에러
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('위치 서비스 비활성화');
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 정보 권한이 없음');
    }
  }

  // 백그라운드 GPS 권한 요청
  PermissionStatus alwaysPermission = await Permission.locationAlways.status;
  if (alwaysPermission == PermissionStatus.granted) {
    return await _geolocatorPlatform.getCurrentPosition();
  } else if (alwaysPermission == PermissionStatus.permanentlyDenied) {
    return Future.error('백그라운드 위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  } else {
    Permission.locationAlways.request();
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
  }

  return await _geolocatorPlatform.getCurrentPosition();
}

void startWalk(Position position, _mapController) {
  // 연속적인 위치 정보 기록에 사용될 설정
  LocationSettings locationSettings;
  if (defaultTargetPlatform == TargetPlatform.android) {
    locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        intervalDuration: const Duration(milliseconds: 500),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "백그라운드에서 위치정보를 받아오고 있습니다.",
          notificationTitle: "견생실록이 백그라운드에서 실행중입니다.",
        ));
  } else if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    locationSettings = AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.fitness,
      distanceFilter: 10,
      pauseLocationUpdatesAutomatically: true,
      showBackgroundLocationIndicator: false,
    );
  } else {
    locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
  }

  var lat = position.latitude, // 위도
      lon = position.longitude; // 경도
  debugPrint('[버튼 클릭]');
  debugPrint('$position');
  debugPrint(lat.toString());
  debugPrint(lon.toString());
  totalWalkLength = 0;
  positionList = [];
  totalWalkLength = 0;

  _mapController.runJavascript('''
                  map.setDraggable(false);
                  map.setZoomable(false);
  ''');

  _positionStreamSubscription = _geolocatorPlatform
      .getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) {
    if (!positionList.contains(position)) {
      if (positionList.length > 0) {
        drawLine(_mapController, position, positionList.last);
      }
      positionList.add(position!);
    }
  });
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
  // 거리 계산
  double distanceInMeters = _geolocatorPlatform
      .bearingBetween(position.latitude, position.longitude, beforePos.latitude,
      beforePos.longitude)
      .abs();
  // 거리 합산
  totalWalkLength += distanceInMeters.toInt();

  // 범위 변경
  //
  // if (bounds.neLat! < lat) {
  //   bounds.neLat = lat;
  // } else if (bounds.swLat! > lat) {
  //   bounds.swLat = lat;
  // }
  //
  // if (bounds.swLng! > lon) {
  //   bounds.swLng = lon;
  // } else if (bounds.neLng! < lon) {
  //   bounds.neLng = lon;
  // }

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
                    
                    // // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
                    // // 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
                    // alert($bounds);
                    // map.setBounds($bounds);
            ''');
}

void stopWalk(_mapController) {
  debugPrint(totalWalkLength.toString());
  _positionStreamSubscription?.cancel(); // 위치 기록 종료
  debugPrint('[종료~~~~(다른 페이지 이동 코드 필요)]');
  _mapController.runJavascript('''
                     map.setDraggable(true);
                     map.setZoomable(true);
  ''');
  debugPrint('산책 끝');
}

class KakaoMapTest extends StatefulWidget {
  final double initLat;
  final double initLng;
  final String kakaoMapKey;

  const KakaoMapTest(this.initLat, this.initLng, this.kakaoMapKey);

  @override
  State<KakaoMapTest> createState() => _KakaoMapTestState();
}

class _KakaoMapTestState extends State<KakaoMapTest> {
  late WebViewController _mapController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // var appBarHeight = AppBar().preferredSize.height;
    debugPrint(widget.initLat.toString());
    debugPrint(widget.initLng.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(title: Text('카카오 맵(산책 경로 예정)')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
            width: size.width,
            // height: size.height * 7 / 10,
            // height: size.height - appBarHeight - 130,
            height: size.height - 130,
            kakaoMapKey: widget.kakaoMapKey,
            lat: widget.initLat,
            lng: widget.initLng,
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
              bounds = KakaoBoundary.fromJson(jsonDecode(message.message));
              debugPrint(
                  '[범위] ne : ${bounds.neLat}, ${bounds.neLng}, sw : ${bounds.swLat}, ${bounds.swLng}');
            },
          ),
          ElevatedButton(
              child: Text('산책 시작'),
              onPressed: () {
                // 1번 기록(최초 위치)
                Future<Position> future = _determinePosition();
                future
                    .then((pos) => startWalk(pos, _mapController))
                    .catchError((error) => debugPrint(error));
              }),
          ElevatedButton(
              child: Text('산책 종료'),
              onPressed: () {
                stopWalk(_mapController);
              })
        ],
      ),
    );
  }
}
