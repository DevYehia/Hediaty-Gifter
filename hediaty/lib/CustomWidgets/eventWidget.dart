/*This Widget Contains:
*Event Name
*Event Date
*Event Category
*Edit Button
*Delete Button
All of which are aligned horizontally
*/
import 'package:flutter/material.dart';

//***For the Future***
//When making real-time upcoming events updates
//this class may be a stateful widget

class EventWidget extends StatelessWidget{
  //Image? friendImage;
  final String eventName;
  final DateTime eventDate;
  final String category;
  final double paddingPixels = 16;
  const EventWidget({super.key, required this.eventName, required this.eventDate, required this.category});
  
  @override
  Widget build(BuildContext context) {

    return InkWell(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Container(
          child: Row( 
            children: [Padding(
              padding: EdgeInsets.all(paddingPixels),
              child: Text(eventName, style: TextStyle(color:Colors.blue,fontFamily: "", fontSize: 24)),
            ),  
            Padding(
              padding: EdgeInsets.all(paddingPixels),
              child: Text(eventDate.toLocal().toString(), style: TextStyle(color:Colors.red))
            ),]
        )
        ),
        Container(child: Row(children: [
        FloatingActionButton(onPressed: (){print("prseddd");}, child: Text("Edit"),),
        FloatingActionButton(onPressed: (){print("prseddd");}, child: Text("Del"),),
        ])
        )
        ]
        ),
        onTap: (){print("Hello jj");}
        );
  }


}