import 'package:flutter/material.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/profilePage.dart';
import 'package:hediaty/darkModeSelection.dart';
import '../CustomWidgets/friend_widget.dart';
import 'eventsPage.dart';
import 'homePage.dart';

class MyFriendPage extends StatefulWidget {
  const MyFriendPage({super.key, required this.friendData});
  final UserModel friendData;
  @override
  State<MyFriendPage> createState() => _MyFriendPageState();
}

class _MyFriendPageState extends State<MyFriendPage> {
  int navCurrIndex = 0;
  StatefulWidget? selectedPage;
  late bool darkMode;

  @override
  void initState() {
    selectedPage = EventPage(
        title: "${widget.friendData.userName}'s Events",
        isOwner: false,
        userID: widget.friendData.userID);
    darkMode = DarkModeSelection.getDarkMode()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: selectedPage,
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: darkMode == false ? Colors.white : Colors.black,
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (Set<WidgetState> states) => darkMode == false
                      ? TextStyle(color: Colors.black)
                      : TextStyle(color: Colors.white)),
              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) => darkMode == false
                      ? IconThemeData(color: Colors.black)
                      : IconThemeData(color: Colors.white)),
            ),
            child: NavigationBar(
              key: Key("OwnerBotNavBar"),
              onDestinationSelected: (int index) {
                setState(() {
                  navCurrIndex = index;
                  if (index == 0) {
                    selectedPage = EventPage(
                        title: "${widget.friendData.userName}'s Events",
                        isOwner: false,
                        userID: widget.friendData.userID);
                  } else if (index == 1) {
                    selectedPage = ProfilePage(
                      userID: widget.friendData.userID,
                      isOwner: false,
                    );
                  }
                });
              },
              indicatorColor: Colors.amber,
              selectedIndex: navCurrIndex,
              destinations: <Widget>[
                NavigationDestination(
                  key: Key("OwnerBotNavBarEvent"),
                  icon: Icon(Icons.notifications_sharp),
                  label: 'My Events',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'My Profile',
                ),
              ],
            )));
  }
}

/*
        onDestinationSelected: (int index) {
          setState(() {
            navCurrIndex = index;
            if(index == 0){
              selectedPage = EventPage(title: "${widget.friendData.userName}'s Events", isOwner: false,userID: widget.friendData.userID);
            }
            else if(index == 1){
              selectedPage = ProfilePage(userID: widget.friendData.userID, isOwner: false,);
            }
          });
        },

*/