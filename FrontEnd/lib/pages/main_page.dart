import 'package:flutter/material.dart';
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
      children: [Flexible(child:Container(color:Colors.blue)),
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

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(title: '견민정음', box_color: Colors.blue, paddings: EdgeInsets.fromLTRB(30, 30, 30, 30),);
  }
}

class health_diagnosis extends StatelessWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(title: '견의보감', box_color: Colors.green, paddings: EdgeInsets.fromLTRB(30, 30, 30, 30),);
  }
}

class diary extends StatelessWidget {
  const diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(title: '견중일기', box_color: Colors.black, paddings: EdgeInsets.fromLTRB(30, 30, 30, 30),);
  }
}



