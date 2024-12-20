import 'package:flutter/material.dart';
import 'package:hediaty/darkModeSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavBar extends StatefulWidget {
  PageController pageSelectController;
  ValueNotifier<int> indexNotifer;
  CustomBottomNavBar(
      {super.key,
      required this.pageSelectController,
      required this.indexNotifer});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int navCurrIndex = 0;
  bool? darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.getDarkMode();
  }

  void updateNavBar(int index) {
    navCurrIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.indexNotifer,
        builder: (BuildContext context, int val, Widget? child) {
          darkMode = DarkModeSelection.darkMode;
          return NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor:
                    darkMode == false ? Colors.white : Colors.black,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) =>
                    darkMode == false ? TextStyle(color: Colors.black) : TextStyle(color: Colors.white) 
                ),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) =>
                    darkMode == false ? IconThemeData(color: Colors.black) :IconThemeData(color: Colors.white) 
                ),
              ),
              child: NavigationBar(
                key: Key("OwnerBotNavBar"),
                onDestinationSelected: (int index) {
                  navCurrIndex = index;
                  widget.pageSelectController.jumpToPage(index);
                  setState(() {});
                },
                indicatorColor: Colors.amber,
                selectedIndex: val,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.person,
                        color: darkMode == false ? Colors.black : Colors.white),
                    label: 'My Friends',
                  ),
                  NavigationDestination(
                    key: Key("OwnerBotNavBarEvent"),
                    icon: Icon(Icons.notifications_sharp),
                    label: 'My Events',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: 'My Profile',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.card_giftcard),
                    label: 'Pledged Gifts',
                  ),
                ],
              ));
        });
  }
}
