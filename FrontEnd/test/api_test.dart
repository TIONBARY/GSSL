// import 'dart:convert';
//
// import 'package:dio/dio.dart';
//
// class Test {
//   Future<bool> test() async {
//     Dio dio = new Dio();
//     try {
//       Response response = await dio.get('j7a204.p.ssafy.io/ssafy123');
//       if (response.statusCode == 200) {
//         final jsonBody = json.decode(response.data); // http와 다른점은 response 값을 data로 받는다.
//         // jsonBody를 바탕으로 data 핸들링
//
//         return true;
//       } else { // 200 안뜨면 에러
//         return false;
//       }
//     } catch (e) {
//       Exception(e);
//     } finally {
//       dio.close();
//     }
//     return false;
//   }
// }
