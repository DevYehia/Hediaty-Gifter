import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/bottomNavBar.dart';
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
  //UserModel loggedInUser = LoggedUser.getLoggedUser();
  String loggedUserID = UserModel.getLoggedUserID();
  PageController pageSwipeController = PageController();
  var currentPageValue = 0.0;
  Key navBarkey = UniqueKey();
  late CustomBottomNavBar botNavBar;
  ValueNotifier<int> botNavBarNotifer = ValueNotifier(0);  

  

  StatefulWidget selectedPage = MyHomePage(title: "Your Friends");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    botNavBar = CustomBottomNavBar(pageSelectController: pageSwipeController, indexNotifer: botNavBarNotifer,);
  }

  void changePage(int newPage){
    pageSwipeController.jumpToPage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    print("Logged User Now is ${loggedUserID}");
    return Scaffold(
      body: PageView(

        controller: pageSwipeController,
        onPageChanged: (value) {
          botNavBarNotifer.value = value;
        },
        children: [
          MyHomePage(title: "Your Friends"),
          EventPage(title: "Your Events", isOwner: true,userID: loggedUserID,),
          ProfilePage(userID: loggedUserID, isOwner: true,),
          PledgedGiftsPage(userID: loggedUserID,)                  
        ],
        ),
      bottomNavigationBar: botNavBar
    );
  }
}
