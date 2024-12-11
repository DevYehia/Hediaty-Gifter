/*This Widget Contains:
*Friend's Icon
*Friend's Name
*Friend's Number of Upcoming Events
All of which are aligned horizontally
*/
import 'package:flutter/material.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/friendPage.dart';


//***For the Future***
//When making real-time upcoming events updates
//this class may be a stateful widget

class FriendWidget extends StatelessWidget{
  //Image? friendImage;
  final UserModel friend;
  final int eventCount;
  final double paddingPixels = 16;
  const FriendWidget({super.key, required this.friend, required this.eventCount});
  
  @override
  Widget build(BuildContext context) {

    late Padding displayedImage;
    if(eventCount != 0 ){
      displayedImage = Padding(padding: EdgeInsets.all(paddingPixels),
      child: Badge.count(
        count: eventCount,
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
              child: Text(friend.userName, style: TextStyle(color:Colors.blue,fontFamily: "Merienda", fontSize: 24)),
          ),  
          ]
        ),
        onTap: (){print("Hello jj");
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyFriendPage(friendData: friend)));
        }
        );
  }


}