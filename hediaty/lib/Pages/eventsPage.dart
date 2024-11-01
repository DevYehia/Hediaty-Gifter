import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Models/user.dart';
import '../CustomWidgets/friend_widget.dart';
class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.title});


  final String title;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {



    List<EventWidget> eventList = [];

    Future setEventList() async{
      List<Event> rawEventList = await Event.getAllEvents(loggedInUser.userID);
      eventList = rawEventList.map((event) => EventWidget(event: event)).toList();
      return eventList;
    }
  //to-do get logged in user properly
  User loggedInUser = User.fromID(1);
  int navCurrIndex = 0;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        //The app's icon
        leading: Image.asset("assets/gift_logo.jpg"),

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.red,
        // Here we take the value from the EventPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: <Widget>[
          IconButton(
            onPressed: (){print("Oi Stop");},
            tooltip: "Add Event",
            icon: const Icon(Icons.add)),
        ],
      ),
      body:  FutureBuilder(
            future: setEventList(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                    return Text("error: ${snapshot.error}");
                }
                return  SingleChildScrollView(
                          child: Center( child: Column(
                            children: eventList
                          )
                          )
                );
              }
              return Text("Hello");
            }
          )
    );
  }
}
