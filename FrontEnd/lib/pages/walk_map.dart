import 'dart:async';
import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/components/pet/pet_detail.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/components/walk/walk_length.dart';
import 'package:GSSL/components/walk/walk_timer.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/put_walk.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:webview_flutter/webview_flutter.dart';

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
List<Position> positionList = [];
StreamSubscription<Position>? _positionStreamSubscription;
int totalWalkLength = 0;
late WebViewController? _mapController;
late StopWatchTimer _stopWatchTimer =
    StopWatchTimer(mode: StopWatchMode.countUp);
bool pressWalkBtn = false;
DateTime startTime = DateTime.now();
DateTime endTime = DateTime.now();
String addrName = "";
String kakaoMapKey = "";
double initLat = 0.0;
double initLon = 0.0;
ApiPet apiPet = ApiPet();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    // statusBarColor: pColor, // status bar color
  ));

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: KakaoMapTest()));
}

class KakaoMapTest extends StatefulWidget {
  @override
  State<KakaoMapTest> createState() => _KakaoMapTestState();
}

class _KakaoMapTestState extends State<KakaoMapTest>
    with AutomaticKeepAliveClientMixin<KakaoMapTest> {
  @override
  bool get wantKeepAlive => true;

  ScreenshotController screenshotController = ScreenshotController();
  Timer? timer;
  User? user;
  List<Pets>? allPets;

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
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getAllPetList();
    } else if (userInfoResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                userInfoResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : userInfoResponse.message!,
                (context) => MainPage());
          });
    }
  }

  Future<void> getAllPetList() async {
    getAllPet? getAllPetResponse = await apiPet.getAllPetApi();
    if (getAllPetResponse.statusCode == 200) {
      setState(() {
        allPets = getAllPetResponse.pets;
      });
    } else if (getAllPetResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                getAllPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : getAllPetResponse.message!,
                (context) => MainPage());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initTimer();
    return
        // Scaffold(
        // resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   toolbarHeight: 0,
        // ),
        // body:
        Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.tight(ScreenUtil.defaultSize),
      child: SnappingSheet(
        // 슬라이드 모달창
        snappingPositions: [
          SnappingPosition.factor(
            positionFactor: 0,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.pixels(
            // 원하는 높이만큼 보임
            positionPixels: 150.h,
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
          ),
        ],
        lockOverflowDrag: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: _future(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                  if (snapshot.hasData == false) {
                    return Image.asset(
                      "assets/images/loadingDog.gif",
                      fit: BoxFit.contain,
                    );
                    // CircularProgressIndicator();
                  }

                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                      style: TextStyle(fontSize: 15),
                    );
                  }

                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                  else {
                    // debugPrint(snapshot.data); Container(
                    // child: Text(snapshot.data),
                    return Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: KakaoMapView(
                        width: 1.sw,
                        // height: size.height * 7 / 10,
                        // height: size.height - appBarHeight - 130,
                        height: 1.sh,
                        kakaoMapKey: kakaoMapKey,
                        lat: initLat,
                        lng: initLon,
                        // zoomLevel: 1,
                        showMapTypeControl: false,
                        showZoomControl: false,
                        draggableMarker: false,
                        // mapType: MapType.TERRAIN,
                        mapController: (controller) {
                          _mapController = controller;
                        },
                        polyline: KakaoFigure(path: []),
                      ),
                    );
                  }
                })
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
            child: Container(
              // 잡는 버튼
              margin: EdgeInsets.fromLTRB(150, 10, 150, 10),
              decoration: new BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            )),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          child: Container(
            // padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
            color: pColor,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WalkLength(totalWalkLength),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CircleAvatar(
                        backgroundColor: btnColor,
                        radius: 20,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: pressWalkBtn
                                ? Icon(Icons.stop)
                                : Icon(Icons.play_arrow),
                            color: nWColor,
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                if (pressWalkBtn == false) {
                                  // 버튼 변경
                                  pressWalkBtn = true;
                                  debugPrint(pressWalkBtn.toString());

                                  // 카카오 맵 이동 기록 시작
                                  Future<Position> future =
                                      _determinePosition();
                                  future
                                      .then((pos) =>
                                          startWalk(pos, _mapController))
                                      .catchError((error) => debugPrint(error));

                                  // 타이머 정지
                                  startTime = DateTime.now();
                                  _stopWatchTimer = StopWatchTimer(
                                      mode: StopWatchMode.countUp);
                                  _stopWatchTimer.onStartTimer();
                                  // _stopWatchTimer.secondTime
                                  //     .listen((value) => print('secondTime $value'));
                                } else if (pressWalkBtn == true) {
                                  // 버튼 변경
                                  pressWalkBtn = false;
                                  debugPrint(pressWalkBtn.toString());

                                  // 카카오 맵 이동 기록 중단
                                  stopWalk(_mapController!);

                                  // 타이머 정지
                                  // _stopWatchTimer.dispose();
                                  _stopWatchTimer.onStopTimer();
                                  endTime = DateTime.now();
                                  // 백엔드 서버로 전송
                                  List<int> pets = [];
                                  for (Pets p in allPets!) {
                                    pets.add(p.id!);
                                  }

                                  putWalk info = new putWalk(
                                      startTime: startTime.toIso8601String(),
                                      endTime: endTime.toIso8601String(),
                                      distance: totalWalkLength,
                                      pet_ids: pets);

                                  ApiWalk apiWalk = ApiWalk();
                                  apiWalk.enterWalk(info);

                                  sleep(Duration(milliseconds: 500));
                                  // 스크린샷 저장
                                  _capturePng();
                                }
                              });
                            }),
                      ),
                    ),
                    WalkTimer(_stopWatchTimer),
//                     // 임시 버튼
//                     CircleAvatar(
//                       child: IconButton(
//                           onPressed: () async {
//                             _capturePng();
// //                             String fileName = DateTime.now()
// //                                 .microsecondsSinceEpoch
// //                                 .toString();
// //                             debugPrint(fileName);
// //                             Directory? directory =
// //                                 await getExternalStorageDirectory(); //from path_provide package
// //                             if (directory != null) {
// //                               debugPrint(directory.toString());
// //                               String path = directory.path + '/' + 'walk';
// //                               new Directory(path).create(recursive: true)
// // // The created directory is returned as a Future.
// //                                   .then((Directory newDirectory) {
// //                                 print('Path of New Dir: ' + newDirectory.path);
// //                               });
// //
// //                               Uint8List? image =
// //                                   await screenshotController.capture(
// //                                       delay: const Duration(milliseconds: 10));
// //                               if (image != null) {
// //                                 print('이미지 사이즈: ' + image.length.toString());
// //                                 final imagePath =
// //                                     await File('${path}/${fileName}.png')
// //                                         .create();
// //                                 await imagePath.writeAsBytes(image);
// //                               }
// //
// //                               screenshotController.captureAndSave(path,
// //                                   fileName: '산책' + fileName + '.png');
// //                             }
//                           },
//                           icon: Icon(Icons.screenshot)),
//                     ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 전체 웹뷰 캡쳐(전체 미디어 파일 접근 권한 필요)
Future<void> _capturePng() async {
  String? path = await NativeScreenshot.takeScreenshot();
  print("찍음");
  debugPrint(path);
  // Directory dir = File(path!).parent;
  String fileName = formatDateTime(endTime.toIso8601String()) + ".png";
  String topFolder = await getDirectory();
  moveFile(File(path!), topFolder + "/" + fileName);
  // print(path);
}

String formatDateTime(String inputTime) {
  String converted = inputTime.trim().split(".").first;
  converted = converted.replaceAll("-", "");
  converted = converted.replaceAll(":", "");
  converted = converted.replaceAll("T", "");
  return converted;
  // try {
  //   int result = int.parse(converted);
  //   return result;
  // } catch (e) {
  //   debugPrint(e.toString());
  //   return 0;
  // }
}

Future<File> moveFile(File sourceFile, String newPath) async {
  try {
    // prefer using rename as it is probably faster
    return await sourceFile.rename(newPath);
  } on FileSystemException catch (e) {
    // if rename fails, copy the source file and then delete it
    debugPrint(e.message);
    final newFile = await sourceFile.copy(newPath);
    Directory tempDir = sourceFile.parent;
    await sourceFile.delete();
    tempDir.deleteSync();
    return newFile;
  }
}

Future<String> getDirectory() async {
  Directory? directory =
      await getExternalStorageDirectory(); //from path_provide package
  if (directory != null) {
    debugPrint(directory.toString());
    String path = directory.path + '/' + 'walk';
    new Directory(path).create(recursive: true)
// The created directory is returned as a Future.
        .then((Directory newDirectory) {
      print('Path of New Dir: ' + newDirectory.path);
    });
    return path;
  }
  return "null";
}

/// 기능 functions
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

  // 백그라운드 GPS 권한 요청
  permission = await _geolocatorPlatform.checkPermission();
  // permission = await Permission.locationAlways.status;
  if (permission == LocationPermission.denied) {
    Permission.locationAlways.request();
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('위치 정보 권한이 없음');
    }
  }

  if (permission == PermissionStatus.granted) {
    return await _geolocatorPlatform.getCurrentPosition();
  } else if (permission == PermissionStatus.permanentlyDenied) {
    return Future.error('백그라운드 위치정보 권한이 영구적으로 거부되어 권한을 요청할 수 없습니다.');
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
  totalWalkLength = 0;
  positionList = [];

  _mapController.runJavascript('''
                  map.setDraggable(false);
                  map.setZoomable(false);
  ''');

  _positionStreamSubscription = _geolocatorPlatform
      .getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) {
    if (!positionList.contains(position)) {
      if (positionList.length > 0) {
        drawLine(_mapController, position!, positionList.last);
      }
      positionList.add(position!);
    }
  });
  if (positionList.length == 0) {
    _mapController.runJavascript('''
                  if ('$position') {
                  // 
                  if (polylineList) {
                      for (i = 0; i < polylineList.length; i++) {
                          // 기존 기록된 경로 삭제
                          polylineList[i].setMap(null);
                      }
                  } 
                  
                  // GeoLocator을 이용해서 얻어온 접속 위치로 이동합니다
                    var lat = parseFloat('$lat'), // 위도
                        lon = parseFloat('$lon'); // 경도
                    var locPosition = new kakao.maps.LatLng(lat, lon);
                    map.setCenter(locPosition);
                      
                  } else { // 위치정보를 사용할 수 없을때 이동할 위치를 설정합니다
                  
                    var locPosition = new kakao.maps.LatLng(37.5013068, 127.0396597); // 멀티캠퍼스 위치
                    map.setCenter(locPosition);
                  }
                  var polylineList = [];
                  var boundList = [];
            ''');
  }
}

void drawLine(
    WebViewController _mapController, Position position, Position beforePos) {
  var lat = 0.0, lon = 0.0;
  var beforeLat = 0.0, beforeLon = 0.0;

  lat = position.latitude;
  lon = position.longitude;
  beforeLat = beforePos.latitude;
  beforeLon = beforePos.longitude;
  // 한 번에 너무 먼 거리 이동(오류/차량 등등) 제외
  // if ((lat * 1000).round() == (beforeLat * 1000).round() ||
  //     (lon * 1000).round() == (beforeLon * 1000).round()) {
  // 거리 계산
  double distanceInMeters = _geolocatorPlatform
      .distanceBetween(position.latitude, position.longitude,
          beforePos.latitude, beforePos.longitude)
      .abs();
  // 거리 합산
  totalWalkLength += distanceInMeters.toInt();
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
                    
                    boundList.push(locPosition); // 바운드 영역 계산용 위치 추가
                    
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
                    polylineList.push(polyline);
            ''');
}

void stopWalk(WebViewController _mapController) {
  debugPrint(totalWalkLength.toString());
  _positionStreamSubscription?.cancel(); // 위치 기록 종료
  _mapController.runJavascript('''
                     map.setDraggable(true);
                     map.setZoomable(true);
                     var bounds = new kakao.maps.LatLngBounds();    
                      for (i = 0; i < boundList.length; i++) {                          
                          // LatLngBounds 객체에 좌표를 추가합니다
                          bounds.extend(boundList[i]);
                      }
                      if ( boundList.length > 1) {
                        map.setBounds(bounds);                      
                      }
                     // bounds[, paddingTop, paddingRight, paddingBottom, paddingLeft]
                     // map.setCenter(new kakao.maps.LatLng(latitude,longitude));
  ''');

  positionList = [];
  debugPrint('산책 끝');
}

// 비동기 처리
Future _future() async {
  WidgetsFlutterBinding.ensureInitialized();
  Position pos = await Geolocator.getCurrentPosition();
  await dotenv.load(fileName: ".env");
  kakaoMapKey = dotenv.get('kakaoMapAPIKey');
  // debugPrint("어싱크 내부");
  initLat = pos.latitude;
  initLon = pos.longitude;
  return kakaoMapKey; // 5초 후 '짜잔!' 리턴
}
