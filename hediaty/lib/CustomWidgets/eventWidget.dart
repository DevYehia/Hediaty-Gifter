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
  const EventWidget({super.key, required this.event});
  
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
              child: Text(DateFormat.yMd().format(event.eventDate), style: TextStyle(color:Colors.red))
            ),]
        )
        ),
        Container(child: Row(children: [
        IconButton(onPressed: (){print(event.eventID);}, icon:Icon(Icons.edit)),
        IconButton(onPressed: (){print("prseddd");}, icon:Icon(Icons.clear)),
        ])
        )
        ]
        ),
        onTap: (){ 

          //to-do
          //get actual gift list from database
          Gift pledgedGift = Gift(name: "Bike", category: "Sport", price: 4000);
          pledgedGift.pledge();
          List<Gift> testGiftList = <Gift>[
          Gift(name: "PS5", category: "Game", price: 10000, description: "On that fateful day, the ball hit the post"),
          Gift(name: "Laptop", category: "Electronics", price: 20000),
          pledgedGift
        ];
          Navigator.push(context, MaterialPageRoute(builder: (context) => GiftPage(title: event.eventName,eventsGiftList: testGiftList,)));}
        );
  }


}