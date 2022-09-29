import 'package:GSSL/components/util/double_click_pop.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/pages/community_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:GSSL/pages/user_info_page.dart';
import 'package:GSSL/pages/walk_map.dart';
import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";

PersistentTabController controller = PersistentTabController(initialIndex: 0);

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _screens = <Widget>[
    MainPage(),
    CommunityApp(),
    KakaoMapTest(),
    UserInfoPage(),
  ];

  List<PersistentBottomNavBarItem> _items() {
    return [
      _btnItem(
        title: "홈",
        icon: Icons.home,
        activeColor: sColor,
      ),
      _btnItem(
        title: "게시판",
        icon: Icons.feed,
        activeColor: sColor,
      ),
      _btnItem(
        title: "산책",
        icon: Icons.pets,
        activeColor: sColor,
      ),
      _btnItem(
        title: "회원정보",
        icon: Icons.person,
        activeColor: sColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        bool result = doubleClickPop();
        return await Future.value(result);
      },
      child: PersistentTabView(
        context,
        controller: controller,
        screens: _screens,
        items: _items(),
        onItemSelected: (index) {},
        backgroundColor: pColor,
        navBarHeight: 62,
        navBarStyle: NavBarStyle.style10,
      ),
    );
  }
}

PersistentBottomNavBarItem _btnItem({
  required String title,
  required IconData icon,
  required Color activeColor,
}) {
  return PersistentBottomNavBarItem(
    title: title,
    icon: Icon(icon, color: btnColor),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    activeColorPrimary: activeColor,
    inactiveColorPrimary: const Color.fromRGBO(195, 195, 195, 1),
    activeColorSecondary: Colors.white,
  );
}
