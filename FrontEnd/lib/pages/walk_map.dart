import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/bottomNavBar.dart';
import '../constants.dart';

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

List<Position> positionList = [];
StreamSubscription<Position>? _positionStreamSubscription;
int totalWalkLength = 0;
var bounds = new KakaoBoundary();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    // statusBarColor: pColor, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();
  Position pos = await _determinePosition();
  await dotenv.load(fileName: ".env");
  String kakaoMapKey = dotenv.get('kakaoMapAPIKey');

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KakaoMapTest(pos.latitude, pos.longitude, kakaoMapKey)));
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
  // 한 번에 너무 먼 거리 이동(오류/차량 등등) 제외
  if ((lat * 1000).round() == (beforeLat * 1000).round() &&
      (lon * 1000).round() == (beforeLon * 1000).round()) {
    // 거리 계산
    double distanceInMeters = _geolocatorPlatform
        .distanceBetween(position.latitude, position.longitude,
            beforePos.latitude, beforePos.longitude)
        .abs();
    // 거리 합산
    totalWalkLength += distanceInMeters.toInt();
  }

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
  late StopWatchTimer _stopWatchTimer =
  StopWatchTimer(mode: StopWatchMode.countUp);
  bool pressWalkBtn = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTimer();
    Size size = MediaQuery.of(context).size;
    // var appBarHeight = AppBar().preferredSize.height;
    debugPrint(widget.initLat.toString());
    debugPrint(widget.initLng.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        child: SnappingSheet( // 슬라이드 모달창
          snappingPositions: [
            SnappingPosition.factor(
              positionFactor: 0,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.pixels( // 원하는 높이만큼 보임
              positionPixels: 150,
              snappingCurve: Curves.elasticOut,
              snappingDuration: Duration(milliseconds: 1750),
            ),
          ],
          lockOverflowDrag: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: KakaoMapView(
                  width: size.width,
                  // height: size.height * 7 / 10,
                  // height: size.height - appBarHeight - 130,
                  height: size.height - 100,
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
              ),
            ],
          ),
          grabbingHeight: 25,
          grabbing: Container(
              decoration: new BoxDecoration(
                color: pColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child : Container(
                margin: EdgeInsets.fromLTRB(150, 10, 150, 10),
                decoration: new BoxDecoration(
                  color: btnColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              )
          ),
          sheetBelow: SnappingSheetContent(
            draggable: true,
            child: Container(
              color: pColor,
              child: Row(
                children: [
                  WalkTimer(_stopWatchTimer),
                  WalkLength(totalWalkLength),
                  CircleAvatar(
                    backgroundColor: btnColor,
                    radius: 20,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: pressWalkBtn ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                        color: Color(0xFFFFFDF4),
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            if (pressWalkBtn == false) {
                              Future<Position> future = _determinePosition();
                              future
                                  .then((pos) => startWalk(pos, _mapController))
                                  .catchError((error) => debugPrint(error));
                              startTime = DateTime.now();
                              _stopWatchTimer =
                                  StopWatchTimer(mode: StopWatchMode.countUp);
                              _stopWatchTimer.onStartTimer();
                              // _stopWatchTimer.secondTime
                              //     .listen((value) => print('secondTime $value'));
                              pressWalkBtn = true;
                              debugPrint(pressWalkBtn.toString());
                            } else if (pressWalkBtn == true) {
                              stopWalk(_mapController);
                              _stopWatchTimer.dispose();
                              // _stopWatchTimer.onStopTimer();
                              endTime = DateTime.now();
                              pressWalkBtn = false;
                              debugPrint(pressWalkBtn.toString());
                            }
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(
          back_com : pColor,
          back_home : pColor,
          back_loc : sColor,
          icon_color_com: btnColor,
          icon_color_home: btnColor,
          icon_color_loc: Color(0xFFFFFDF4)),
    ); // 수정중
  }
}
