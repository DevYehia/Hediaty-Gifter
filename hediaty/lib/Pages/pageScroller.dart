import 'package:flutter/material.dart';
import 'package:hediaty/Pages/eventsPage.dart';
import 'package:hediaty/Pages/homePage.dart';
import 'package:hediaty/Pages/pledgedGiftsPage.dart';
import 'package:hediaty/Pages/profilePage.dart';

class PageScroller extends StatefulWidget {

  String loggedUserID;
  PageController pageSwipeController;
  PageScroller({super.key, required this.loggedUserID, required this.pageSwipeController});

  @override
  State<PageScroller> createState() => _PageScrollerState();
}

class _PageScrollerState extends State<PageScroller> {
  var currentPageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: widget.pageSwipeController,
        children: [
          MyHomePage(title: "Your Friends"),
          EventPage(title: "Your Events", isOwner: true,userID: widget.loggedUserID,),
          ProfilePage(userID: widget.loggedUserID,),
          PledgedGiftsPage(userID: widget.loggedUserID,)                  
        ],
        );
  }
}