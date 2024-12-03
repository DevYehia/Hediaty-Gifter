import 'package:flutter/material.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/pledgedGiftsPage.dart';
import 'package:hediaty/Pages/profilePage.dart';
import '../CustomWidgets/friend_widget.dart';
import 'eventsPage.dart';
import 'homePage.dart';


class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});
  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int navCurrIndex = 0;
  UserModel loggedInUser = LoggedUser.getLoggedUser();

  StatefulWidget selectedPage = MyHomePage(title: "Your Friends");
  @override
  Widget build(BuildContext context) {
    print("Logged User Now is ${loggedInUser.userID}");
    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            navCurrIndex = index;
            if(index == 0){
              selectedPage = MyHomePage(title: "Your Friends");
            }
            else if(index == 1){
              selectedPage = EventPage(title: "Your Events", isOwner: true,userID: loggedInUser.userID,);
            }
            else if(index == 2){
              selectedPage = ProfilePage();
            }
            else if(index == 3){
              selectedPage = PledgedGiftsPage(userID: loggedInUser.userID,);
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: navCurrIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'My Friends',
          ),
          NavigationDestination(
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
      ),
    );
  }
}
