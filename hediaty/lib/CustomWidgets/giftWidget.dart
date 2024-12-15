import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
  late StreamSubscription<DatabaseEvent> pledgeListener;
  bool isNotDeleted = true;

  //update gift pledge status if someone pledged a gift in realtime
  void updatePledgeStatus(String pledgerID){
    if(widget.gift.pledgerID != pledgerID){

      //update localDB if pledge/unpledge happens
      //to test --> calling without await
      if(widget.isOwner){
        Gift.updatePledgerLocal(pledgerID, widget.gift.ID);
      }
      //update pledger ID
      widget.gift.pledgerID = pledgerID;
      String snackMessage = pledgerID == "" ?  "${widget.gift.name} has been unPledged :(" : "${widget.gift.name} has been pledged!!" ;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackMessage)));
      setState(() {
        
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pledgeListener = Gift.attachListenerForPledge(widget.gift.ID, updatePledgeStatus);
    
  }


  @override
  Widget build(BuildContext context) {
    bool showPledgedStyle = (widget.gift.pledgerID == "") ? false : true;
    return isNotDeleted ? InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(child: Row(
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
              ]
          )
          ),
          IconButton(
            onPressed: () async{
              //delete Gift
              await Gift.deleteGiftLocal(widget.gift.ID);
              await Gift.deleteGiftFirebase(widget.gift.ID);
              isNotDeleted = false;
              setState(() {
                
              });
            }, 
            icon: Icon(Icons.clear)
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
        
    ) : SizedBox.shrink();
    
    
  }



}