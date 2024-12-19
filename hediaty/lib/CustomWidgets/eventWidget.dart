import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventEditingDialog.dart';
import 'package:hediaty/ModelView/EventModelView.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/giftPage.dart';
import 'package:hediaty/darkModeSelection.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EventOption { Publish, Edit, Delete, Hide }

//Widget is now stateful :)
class EventWidget extends StatefulWidget {
  Event event;
  final bool isOwner;
  final EventModelView modelView;
  EventWidget(
      {super.key,
      required this.event,
      required this.isOwner,
      required this.modelView});

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final double paddingPixels = 16;
  DateFormat dateFormatter = DateFormat("d/M/y");
  late Color nameColor;
  bool? darkMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    darkMode = DarkModeSelection.darkMode;
    nameColor = widget.event.firebaseID == null ? Colors.red : Colors.blue;
    if(!widget.isOwner){
      widget.modelView.listenForEventChange(widget.event);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("I am Disposed!!!");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GiftPage(
              title: widget.event.eventName,
              event: widget.event,
              isOwner: widget.isOwner,
              userID: widget.event.userID,
            ),
          ),
        );
      },
      child: Card(
        color: darkMode == null || darkMode == false ? Colors.white : Colors.black,
        shadowColor: darkMode == null || darkMode == false ? Colors.black : Colors.white,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(paddingPixels),
                child: Text(
                  widget.event.eventName,
                  style: TextStyle(
                    color: widget.event.firebaseID == null
                        ? Colors.red
                        : Colors.blue,
                    fontFamily: "",
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(paddingPixels),
                child: Text(
                  dateFormatter.format(widget.event.eventDate),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          if (widget.isOwner)
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: darkMode == false ? Colors.black : Colors.white,),
              onSelected: (value) async {
                if (value == EventOption.Publish) {
                  widget.event.firebaseID =
                      await widget.modelView.publishEvent(widget.event);
                  print("firebase ID now is ${widget.event.firebaseID}");
                  setState(() {});
                } else if (value == EventOption.Edit) {
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
                /*else if(value == EventOption.Hide){
                  await widget.modelView.hideEvent(widget.event.firebaseID!, widget.event.userID, widget.event.eventID);
                  widget.event.firebaseID = null;
                  setState(() {});
                }*/
              },
              itemBuilder: (context) => [

                if(widget.event.firebaseID == null)
                PopupMenuItem(
                    child: Text("Publish"), value: EventOption.Publish),
                /*if(widget.event.firebaseID != null)
                PopupMenuItem(
                    child: Text("Hide"), value: EventOption.Hide),
                */                
                if (widget.event.eventDate.isAfter(DateTime
                    .now())) //display event editing only if it is not past event
                  PopupMenuItem(value: EventOption.Edit, child: Text("Edit")),
                PopupMenuItem(value: EventOption.Delete, child: Text("Delete"))
              ],
            ),
        ],
      ),
    )
    );
  }
}
