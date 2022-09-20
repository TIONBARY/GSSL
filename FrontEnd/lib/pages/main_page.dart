import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("메인 페이지")),
      body: Container(child: Column(
        children: [
          Flexible(child: UserBar(),flex: 1,),
          Flexible(child: behavior_diagnosis(),flex: 2,),
          Flexible(child: health_diagnosis(),flex: 2,),
          Flexible(child: diary(),flex: 2,),
        ],
      ),),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.menu),onPressed: () {},),
            IconButton(icon: Icon(Icons.search),onPressed: () {},),
            IconButton(icon: Icon(Icons.star),onPressed: () {},),
            IconButton(icon: Icon(Icons.more_vert),onPressed: () {},),
          ],
        ),
      ),
    );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Row(
      children: [
        Flexible(child: Container(color:Colors.green,
          child: OutlineCircleButton(
            child: Icon(Icons.account_box_rounded),
          ),),flex: 1,),
        Flexible(child: Container(child: Column(
          children: [
            Flexible(child: Container(color:Colors.black, 
              child: Container(child: Text("주인의 멍멍이", style: TextStyle(color: Colors.white),), width: double.infinity, height: double.infinity,) ,),flex: 1,),
            Flexible(child: Container(color:Colors.red,
              child: Container(child: Text("건강하자", style: TextStyle(color: Colors.white),), width: double.infinity, height: double.infinity,) ,),flex: 1,),
          ],
        ),
        ),flex: 3,),
        Flexible(child: Container(color:Colors.green,
        child:
        Container(child: Icon(Icons.phone), width: double.infinity, height: double.infinity,),),
          flex: 1,),
      ],
    ),);
  }
}

class behavior_diagnosis extends StatefulWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  State<behavior_diagnosis> createState() => _behavior_diagnosisState();
}

class _behavior_diagnosisState extends State<behavior_diagnosis> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(child: Column(
        children: [
          Flexible(child: Container(width:480, height:360, color:Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("견민정음",style: TextStyle(fontSize: 40,),),
                    ),
                  ],
                ),
                  width: 200, height: 100, color: Colors.red,),
              ],
            ),),flex: 1,),
        ],
      ),),
    );;
  }
}

class health_diagnosis extends StatefulWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  State<health_diagnosis> createState() => _health_diagnosisState();
}

class _health_diagnosisState extends State<health_diagnosis> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(child: Column(
        children: [
          Flexible(child: Container(width:480, height:360, color:Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("견의보감",style: TextStyle(fontSize: 40,),),
                    ),
                  ],
                ),
                  width: 200, height: 100, color: Colors.red,),
              ],
            ),),flex: 1,),
        ],
      ),),
    );;
  }
}

class diary extends StatefulWidget {
  const diary({Key? key}) : super(key: key);

  @override
  State<diary> createState() => _diaryState();
}

class _diaryState extends State<diary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(child: Column(
        children: [
          Flexible(child: Container(width:480, height:360, color:Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("견중일기",style: TextStyle(fontSize: 40,),),
                    ),
                  ],
                ),
                  width: 200, height: 100, color: Colors.red,),
              ],
            ),),flex: 1,),
        ],
      ),),
    );;
  }
}

class OutlineCircleButton extends StatelessWidget {
  OutlineCircleButton({
    Key key,
    this.onTap,
    this.borderSize: 0.5,
    this.radius: 20.0,
    this.borderColor: Colors.black,
    this.foregroundColor: Colors.white,
    this.child,
  }) : super(key: key);

  final onTap;
  final radius;
  final borderSize;
  final borderColor;
  final foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderSize),
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              child: child??SizedBox(),
              onTap: () async {
                if(onTap != null) {
                  onTap();
                }
              }
          ),
        ),
      ),
    );
  }
}