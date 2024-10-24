import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import '../CustomWidgets/friend_widget.dart';
class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.title});


  final String title;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  int navCurrIndex = 0;
  @override
  Widget build(BuildContext context) {

    List<EventWidget> testEventList = List<EventWidget>.filled(20,EventWidget(eventName: "Nkset 24", eventDate: DateTime.now(), category: "Sadness"),growable: false);
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
      body:  SingleChildScrollView(
        child: Center( child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          children: testEventList
        )
    )
      ),
    );
  }
}
