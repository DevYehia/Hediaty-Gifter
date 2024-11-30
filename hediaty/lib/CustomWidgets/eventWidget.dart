/*This Widget Contains:
*Event Name
*Event Date
*Event Category
*Edit Button
*Delete Button
All of which are aligned horizontally
*/
import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Pages/giftPage.dart';
import 'package:intl/intl.dart';

//***For the Future***
//When making real-time upcoming events updates
//this class may be a stateful widget

class EventWidget extends StatelessWidget{
  //Image? friendImage;
  final Event event;
  final double paddingPixels = 16;
  final bool isOwner;
  const EventWidget({super.key, required this.event, required this.isOwner});
  
  @override
  Widget build(BuildContext context) {

    return InkWell(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Container(
          child: Row( 
            children: [Padding(
              padding: EdgeInsets.all(paddingPixels),
              child: Text(event.eventName, style: TextStyle(color:Colors.blue,fontFamily: "", fontSize: 24)),
            ),  
            Padding(
              padding: EdgeInsets.all(paddingPixels),
              //child: Text(DateFormat.yMd().format(event.eventDate), style: TextStyle(color:Colors.red))
              child: Text(DateFormat.yMd().format(event.eventDate), style: TextStyle(color:Colors.red))
            ),]
        )
        ),
        //display edit and delete buttons only if user owns event
        Container(child: Row(children: isOwner ? [
        IconButton(onPressed: (){print(event.eventID);}, icon:Icon(Icons.edit)),
        IconButton(onPressed: (){print("prseddd");}, icon:Icon(Icons.clear)),
        ] : 
        [])
        )
        ]
        ),
        onTap: (){ 

          Navigator.push(context, MaterialPageRoute(builder: (context) => GiftPage(title: event.eventName, eventID: event.eventID, isOwner: isOwner,userID: event.userID,)));}
        );
  }


}