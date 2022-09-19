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
          Flexible(child: FunctionBox(),flex: 2,),
          Flexible(child: FunctionBox(),flex: 2,),
          Flexible(child: FunctionBox(),flex: 2,),
        ],
      ),),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu),onPressed: () {},),
            IconButton(icon: Icon(Icons.search),onPressed: () {},),
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
        Flexible(child: Container(color:Colors.green),flex: 1,),
        Flexible(child: Container(child: Column(
          children: [
            Flexible(child: Container(color:Colors.black),flex: 1,),
            Flexible(child: Container(color:Colors.red),flex: 1,),
          ],
        ),
        ),flex: 3,),
        Flexible(child: Container(color:Colors.green),flex: 1,),
      ],
    ),);
  }
}

class FunctionBox extends StatefulWidget {
  const FunctionBox({Key? key}) : super(key: key);

  @override
  State<FunctionBox> createState() => _FunctionBoxState();
}

class _FunctionBoxState extends State<FunctionBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(child: Column(
        children: [
          Flexible(child: Container(color:Colors.yellow),flex: 1,),
          Flexible(child: Container(color:Colors.blue),flex: 2,),
          Flexible(child: Container(color:Colors.red),flex: 1,),
        ],
      ),),
    );
  }
}
