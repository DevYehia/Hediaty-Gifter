/*This Widget Contains:
*Friend's Icon
*Friend's Name
*Friend's Number of Upcoming Events
All of which are aligned horizontally
*/
import 'package:flutter/material.dart';
import '../Models/friend.dart';

//***For the Future***
//When making real-time upcoming events updates
//this class may be a stateful widget

class FriendWidget extends StatelessWidget{
  //Image? friendImage;
  final String friendName;
  final int upcomingEvents = 2;
  final double paddingPixels = 16;
  const FriendWidget({super.key, required this.friendName});
  
  @override
  Widget build(BuildContext context) {

    late Padding displayedImage;
    if(upcomingEvents != 0 ){
      displayedImage = Padding(padding: EdgeInsets.all(paddingPixels),
      child: Badge.count(
        count: upcomingEvents,
        child: CircleAvatar(radius: 40, backgroundImage:AssetImage("assets/youssef.jpeg"))
        )
      );
    }
    else{
      displayedImage = Padding(padding: EdgeInsets.all(paddingPixels),
        child: CircleAvatar(radius: 40, backgroundImage:AssetImage("assets/youssef.jpeg"))
      );
    }

    return InkWell(
        child: Row(children: [
          displayedImage,
          Padding(
              padding: EdgeInsets.all(paddingPixels),
              child: Text(friendName, style: TextStyle(color:Colors.blue,fontFamily: "Merienda", fontSize: 24)),
          ),  
          ]
        ),
        onTap: (){print("Hello jj");}
        );
  }


}