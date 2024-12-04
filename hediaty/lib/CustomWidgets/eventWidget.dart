import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Pages/giftPage.dart';


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
                    widget.event.eventDate.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            if (widget.isOwner)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Edit button functionality here
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Event.removeEventLocal(widget.event.eventID);
                      await Event.removeEventFirebase(widget.event.eventID);
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
