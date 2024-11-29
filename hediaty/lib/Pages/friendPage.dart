import 'package:flutter/material.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/profilePage.dart';
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
  StatefulWidget? selectedPage = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            navCurrIndex = index;
            if(index == 0){
              selectedPage = EventPage(title: "${widget.friendData.userName}'s Events", isOwner: false,userID: widget.friendData.userID);
            }
            else if(index == 1){
              selectedPage = ProfilePage();
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: navCurrIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}