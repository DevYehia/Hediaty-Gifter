import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventEditingDialog.dart';
import 'package:hediaty/ModelView/EventModelView.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/giftPage.dart';
import 'package:intl/intl.dart';

enum EventOption {Publish, Edit, Delete}
//Widget is now stateful :)
class EventWidget extends StatefulWidget {
  final Event event;
  final bool isOwner;
  final EventModelView modelView;
  const EventWidget(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameColor = widget.event.firebaseID == null ? Colors.red : Colors.blue;
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
              eventID: widget.event.eventID.toString(),
              isOwner: widget.isOwner,
              userID: widget.event.userID,
            ),
          ),
        );
      },
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
                    color: nameColor,
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
              icon: Icon(Icons.more_vert),
              onSelected: (value) async{
                if(value == EventOption.Publish){
                  await widget.modelView.publishEvent(widget.event);

                  setState(() {
                    
                  });

                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(child: Text("Publish"), value: EventOption.Publish),
                PopupMenuItem(
                  value: EventOption.Edit,
                  child: //display event editing only if it is not past event
                      widget.event.eventDate.isAfter(DateTime.now())
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EventEditingDialog(
                                          setStateCallBack: () {
                                            setState(() {});
                                          },
                                          eventToModify: widget.event,
                                          modelView: widget.modelView);
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            )
                          : SizedBox.shrink(),
                ),
                PopupMenuItem(
                  value: EventOption.Delete,
                  child: IconButton(
                    onPressed: () async {
                      await widget.modelView.removeEvent(widget.event);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
