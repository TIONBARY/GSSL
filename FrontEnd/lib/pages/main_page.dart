import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widget/main_function_box.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        color: Color(0xFFFFFDF4),
        child: Column(
          children: [
            Flexible(
              child: UserBar(),
              flex: 1,
            ),
            Flexible(
              child: behavior_diagnosis(),
              flex: 2,
            ),
            Flexible(
              child: health_diagnosis(),
              flex: 2,
            ),
            Flexible(
              child: diary(),
              flex: 2,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFFE6BC),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.people_alt_outlined,
                  size: 30,
                  color: Color(0xFFFFF3E4),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: Color(0xFF483434),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.location_on_outlined,
                  size: 30,
                  color: Color(0xFFFFF3E4),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: Color(0xFFFFE6BC),
      ),
      child: Row(
        children: [
          Flexible(
              child: Container(
                // color: Colors.blue
              )),
          Flexible(
            child: Container(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          "주인의 멍멍이",
                          style: TextStyle(color: Color(0xFF483434)),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          "건강하자",
                          style: TextStyle(
                            color: Color(0xFF483434),
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            flex: 3,
          ),
          Flexible(
            child: Container(
              // color: Colors.green,
              child: Container(
                child: Icon(
                  Icons.wifi_protected_setup_outlined,
                  color: Color(0xFF483434),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x80DFB45B),
      paddings: EdgeInsets.fromLTRB(30, 30, 30, 15),
    );
  }
}

class health_diagnosis extends StatelessWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견의보감',
      box_color: Color(0x80506274),
      paddings: EdgeInsets.fromLTRB(30, 15, 30, 15),
    );
  }
}

class diary extends StatelessWidget {
  const diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x80C66952),
      paddings: EdgeInsets.fromLTRB(30, 15, 30, 30),
    );
  }
}
