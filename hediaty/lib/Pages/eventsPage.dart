import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventCreationDialog.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Models/user.dart';
import '../CustomWidgets/friend_widget.dart';
class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.title, required this.isOwner, required this.userID});


  final String title;
  final bool isOwner;
  final String userID;

  @override
  State<EventPage> createState() => _EventPageState();


}

class _EventPageState extends State<EventPage> {


    //attach a listener to user's event Count to update page accordingly
    @override
    void initState() {
      super.initState();
      //listen for changes on friend's eventCount
      var eventCountRef = FirebaseDatabase.instance.ref("Users/${widget.userID}/eventCount");
      eventCountRef.onValue.listen((event) {
        setState(() {
            
        });
        }
      ,);
    }

    List<EventWidget> eventList = [];

    Future setEventList() async{



      //if user is event's owner, get locally otherwise get from firebase

      late List<Event> rawEventList;
      if(widget.isOwner){
        rawEventList = await Event.getAllEvents(widget.userID);
      }
      else{
        rawEventList = await Event.getAllEventsFirebase(widget.userID);
      }
      eventList = rawEventList.map((event) => EventWidget(event: event, isOwner: widget.isOwner,)).toList();


    
      return eventList;
    }

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

        //display add event button if user owns event
        actions: widget.isOwner ? 
        <Widget>[
          IconButton(
            onPressed: (){showDialog(context: context, builder: (BuildContext context){
              return EventCreationDialog(setStateCallBack: (){setState(() {
                
              });});
            }
            );
            },
            tooltip: "Add Event",
            icon: const Icon(Icons.add)),
        ]: 
        null,
      ),
      body:  FutureBuilder(
            future: setEventList(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator()); 
              }
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
