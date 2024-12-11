import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventEditingDialog.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Pages/giftPage.dart';
import 'package:intl/intl.dart';


//Widget is now stateful :)
class EventWidget extends StatefulWidget {
  final Event event;
  final bool isOwner;

  const EventWidget({
    super.key,
    required this.event,
    required this.isOwner,
  });

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {

  final double paddingPixels = 16;
  bool isRemoved = false;
  DateFormat dateFormatter = DateFormat("d/M/y");
  @override
  Widget build(BuildContext context) {
    if(!isRemoved){
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiftPage(
                title: widget.event.eventName,
                eventID: widget.event.eventID,
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
                    style: const TextStyle(
                      color: Colors.blue,
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
              Row(
                children: [

                  //display event editing only if it is not past event
                  widget.event.eventDate.isAfter(DateTime.now()) ? IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (BuildContext context){
                        return EventEditingDialog(
                          setStateCallBack: (){setState(() {
                            
                          });},
                          eventToModify: widget.event
                          );

                    });
                    },
                    icon: const Icon(Icons.edit),
                  ) : SizedBox.shrink(),
                  IconButton(
                    onPressed: () async {
                      await Event.removeEventLocal(widget.event.eventID);
                      await Event.removeEventFirebase(widget.event.eventID);
                      await UserModel.decrementEventCounter(widget.event.userID);
                      setState(() {
                        isRemoved = true;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
          ],
        ),
      );
    }
    else{
      return SizedBox.shrink();
    }
  }
}
