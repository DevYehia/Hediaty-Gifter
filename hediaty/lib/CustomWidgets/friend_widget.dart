/*This Widget Contains:
*Friend's Icon
*Friend's Name
*Friend's Number of Upcoming Events
All of which are aligned horizontally
*/
import 'package:flutter/material.dart';

//***For the Future***
//When making real-time upcoming events updates
//this class may be a stateful widget

class FriendWidget extends StatelessWidget{
  //Image? friendImage;
  final String friendName;
  final int upcomingEvents = 0;
  final double paddingPixels = 16;
  const FriendWidget({super.key, required this.friendName});
  
  @override
  Widget build(BuildContext context) {
    String upcomingEventsMsg = "Events: $upcomingEvents";
    Padding displayedImage = Padding(padding: EdgeInsets.all(paddingPixels),
    child: CircleAvatar(radius: 40, backgroundImage:AssetImage("assets/youssef.jpeg")));

    return InkWell(
        child: Row(children: [
        displayedImage,
        Padding(
            padding: EdgeInsets.all(paddingPixels),
            child: Text(friendName, style: TextStyle(color:Colors.blue,fontFamily: "", fontSize: 24)),
        ),  
        Padding(
            padding: EdgeInsets.all(paddingPixels),
            child: Text(upcomingEventsMsg, style: TextStyle(color:Colors.red))
        )]
        ),
        onTap: (){print("Hello jj");}
        );
  }


}