import 'package:flutter/material.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Pages/giftDescriptionPage.dart';

//This widget contains
//* Gift Image (if found)
//* Gift Name
//* Gift Status (Pledged or not)


class GiftWidget extends StatefulWidget{
  Gift gift;
  final bool isOwner;
  final String userID;
  GiftWidget({required this.gift, required this.isOwner, required this.userID});
  @override
  State<StatefulWidget> createState() {
    return GiftWidgetState();
  }

  
}

class GiftWidgetState extends State<GiftWidget>{
  double paddingPixels = 16;
  @override
  Widget build(BuildContext context) {
    bool showPledgedStyle = (widget.gift.pledgerID == null) ? false : true;
    return InkWell(
      child: Row(
        children: [
          Padding(
            child: Icon(Icons.image),
            padding: EdgeInsets.all(paddingPixels)
          ),
          Padding(
          child:  Text(widget.gift.name!, style: TextStyle(
              color: (showPledgedStyle ? Colors.red : Colors.green),
              fontSize: 16
            )
            ),
          padding: EdgeInsets.all(paddingPixels)
          )

        ],),
        onTap: () {
          //to-do 
          //make gift description page
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => GiftDescriptionPage(
              title: widget.gift.name!,
              gift: widget.gift, 
              isOwner: widget.isOwner,
              isPledged: showPledgedStyle,
              userID: widget.userID, )));
        },
    );
    
    
  }



}