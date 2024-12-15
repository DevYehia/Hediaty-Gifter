import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Pages/giftDescriptionPage.dart';

//This widget contains
//* Gift Image (if found)
//* Gift Name
//* Gift Status (Pledged or not)

enum EventOption { Publish, Edit, Delete, Hide }
class GiftWidget extends StatefulWidget{
  Gift gift;
  final bool isOwner;
  final String userID;
  final GiftModelView modelView;
  GiftWidget({required this.gift, required this.isOwner, required this.userID, required this.modelView});
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
    if(widget.gift.firebaseID != null){
      pledgeListener = Gift.attachListenerForPledge(widget.gift.firebaseID!, updatePledgeStatus);
    }
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
          if (widget.isOwner)
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == EventOption.Publish) {
                  widget.gift.firebaseID =
                      await widget.modelView.publishGift(widget.gift);
                  //print("firebase ID now is ${widget.event.firebaseID}");
                  setState(() {});
                }
                /* else if (value == EventOption.Edit) {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EventEditingDialog(
                            setStateCallBack: () {
                              setState(() {});
                            },
                            eventToModify: widget.event,
                            modelView: widget.modelView);
                      });
                  setState(() {});
                } else if (value == EventOption.Delete) {
                  await widget.modelView.removeEvent(widget.event);
                }
                else if(value == EventOption.Hide){
                  await widget.modelView.hideEvent(widget.event.firebaseID!, widget.event.userID, widget.event.eventID);
                  widget.event.firebaseID = null;
                  setState(() {});
                }*/
              },
              itemBuilder: (context) => [

                if(widget.gift.firebaseID == null)
                PopupMenuItem(
                    child: Text("Publish"), value: EventOption.Publish),
                if(widget.gift.firebaseID != null)
                PopupMenuItem(
                    child: Text("Hide"), value: EventOption.Hide),                
                if (widget.gift.pledgerID == null || widget.gift.pledgerID == "") //display event editing only if it is not past event
                  PopupMenuItem(value: EventOption.Edit, child: Text("Edit")),
                PopupMenuItem(value: EventOption.Delete, child: Text("Delete"))
              ],
            ),

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