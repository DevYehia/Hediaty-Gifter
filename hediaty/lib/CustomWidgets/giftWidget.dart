import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/GiftEditingDialog.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Pages/giftDescriptionPage.dart';
import 'package:hediaty/darkModeSelection.dart';

//This widget contains
//* Gift Image (if found)
//* Gift Name
//* Gift Status (Pledged or not)

enum EventOption { Publish, Edit, Delete, Hide }

class GiftWidget extends StatefulWidget {
  Gift gift;
  final bool isOwner;
  final String userID;
  final GiftModelView modelView;
  final bool isEventFinished;
  GiftWidget(
      {required this.gift,
      required this.isOwner,
      required this.userID,
      required this.modelView,
      required this.isEventFinished});
  @override
  State<StatefulWidget> createState() {
    return GiftWidgetState();
  }
}

class GiftWidgetState extends State<GiftWidget> {
  double paddingPixels = 16;
  late StreamSubscription<DatabaseEvent> pledgeListener;
  bool isNotDeleted = true;
  late String notPublishedMessage;
  bool? darkMode;

  //update gift pledge status if someone pledged a gift in realtime
  void updatePledgeStatus(String newPledgerID) {
    String? pledgerID = newPledgerID == "" ? null : newPledgerID;
    if (widget.gift.pledgerID != pledgerID) {
      print("New pledgerID is ${pledgerID}");

      //update localDB if pledge/unpledge happens
      //to test --> calling without await
      if (widget.isOwner) {
        Gift.updatePledgerLocal(newPledgerID, widget.gift.ID);
      }
      //update pledger ID
      widget.gift.pledgerID = pledgerID;
      String snackMessage = newPledgerID == ""
          ? "${widget.gift.name} has been unPledged :("
          : "${widget.gift.name} has been pledged!!";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(snackMessage)));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    notPublishedMessage =
        (widget.gift.firebaseID == null || widget.gift.firebaseID == "")
            ? "Not Published"
            : "";
    darkMode = DarkModeSelection.getDarkMode();
    if (widget.gift.firebaseID != null) {
      pledgeListener = Gift.attachListenerForPledge(
          widget.gift.firebaseID!, updatePledgeStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    notPublishedMessage =
        (widget.gift.firebaseID == null || widget.gift.firebaseID == "")
            ? "Not Published"
            : "";
    bool showPledgedStyle =
        (widget.gift.pledgerID == "" || widget.gift.pledgerID == null)
            ? false
            : true;
    return isNotDeleted
        ? InkWell(
            child: Card(
              color: darkMode == false ? Colors.white : Colors.black,
              shadowColor: darkMode == false ? Colors.black : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Row(children: [
                    Padding(
                        child: Icon(Icons.card_giftcard,
                            color: darkMode == false
                                ? Colors.black
                                : Colors.white),
                        padding: EdgeInsets.all(paddingPixels)),
                    Padding(
                        child: Text(widget.gift.name!,
                            style: TextStyle(
                                color: (showPledgedStyle
                                    ? Colors.red
                                    : Colors.green),
                                fontSize: 16)),
                        padding: EdgeInsets.all(paddingPixels)),
                    Text(notPublishedMessage,
                        style: TextStyle(color: Colors.red))
                  ])),

                  //no editing if gifts are pledged or not the owner
                  if (widget.isOwner &&
                      (widget.gift.pledgerID == null ||
                          widget.gift.pledgerID == "") &&
                      !widget.isEventFinished)
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert,
                          color:
                              darkMode == false ? Colors.black : Colors.white),
                      onSelected: (value) async {
                        if (value == EventOption.Publish) {
                          widget.gift.firebaseID =
                              await widget.modelView.publishGift(widget.gift);
                          //print("firebase ID now is ${widget.event.firebaseID}");
                          setState(() {});
                        } else if (value == EventOption.Edit) {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GiftEditingDialog(
                                    setStateCallBack: () {
                                      setState(() {});
                                    },
                                    giftToModify: widget.gift,
                                    modelView: widget.modelView);
                              });
                          setState(() {});
                        } else if (value == EventOption.Delete) {
                          await widget.modelView.removeGift(widget.gift);
                        }
                      },
                      itemBuilder: (context) => [
                        if (widget.gift.firebaseID == null &&
                            widget.modelView.event.firebaseID != null)
                          PopupMenuItem(
                              child: Text("Publish"),
                              value: EventOption.Publish),
                        /*if(widget.gift.firebaseID != null)
                PopupMenuItem(
                    child: Text("Hide"), value: EventOption.Hide),*/
                        PopupMenuItem(
                            value: EventOption.Edit, child: Text("Edit")),
                        PopupMenuItem(
                            value: EventOption.Delete, child: Text("Delete"))
                      ],
                    ),
                ],
              ),
            ),
            onTap: () {
              //to-do
              //make gift description page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GiftDescriptionPage(
                            title: widget.gift.name!,
                            gift: widget.gift,
                            isOwner: widget.isOwner,
                            isPledged: showPledgedStyle,
                            userID: widget.userID,
                            isEventFinished: widget.isEventFinished,
                          )));
            },
          )
        : SizedBox.shrink();
  }
}
