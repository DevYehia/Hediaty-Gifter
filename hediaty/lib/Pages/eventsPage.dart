import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/EventFilterDIalog.dart';
import 'package:hediaty/CustomWidgets/eventCreationDialog.dart';
import 'package:hediaty/ModelView/EventModelView.dart';
import 'package:hediaty/Util/Events/EventDateSort.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';
import 'package:hediaty/Util/Events/EventNameSort.dart';
import 'package:hediaty/Util/Events/EventSortStrategy.dart';

enum SortCategories { nameSort, dateSort }

class EventPage extends StatefulWidget {
  const EventPage(
      {super.key,
      required this.title,
      required this.isOwner,
      required this.userID});

  final String title;
  final bool isOwner;
  final String userID;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late EventModelView modelView;
  EventSortStrategy? selectedSort;
  //attach a listener to user's event Count to update page accordingly
  @override
  void initState() {
    super.initState();
    modelView = EventModelView(
        userID: widget.userID,
        isOwner: widget.isOwner,
        refreshCallback: () {
          setState(() {});
        },
        addedUIUpdate: addedEventNotif,
        editedUIUpdate: editedEventNotif,
        removedUIUpdate: removedEventNotif);
  }


  void addedEventNotif(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New Event Has Been Added")));
  }

  void removedEventNotif(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An Event has been removed ):")));    
  }

  void editedEventNotif(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An Event has been edited")));       
  }

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
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  List<EventFilter> selectedFilters = [];
                  selectedFilters = (await showDialog(
                        context: context,
                        builder: (context) => EventFilterDialog(
                        ),
                      )) ??
                      selectedFilters;
                  modelView.setFilters(selectedFilters);
                  setState(() {});
                },
                icon: Icon(Icons.filter_alt)),
            PopupMenuButton<EventSortStrategy>(
              initialValue: selectedSort,
              icon: const Icon(
                Icons.menu,
              ), //use this icon
              onSelected: (EventSortStrategy item) {
                setState(() {
                  selectedSort = item;
                  modelView.setSort(item);
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<EventSortStrategy>>[
                PopupMenuItem<EventSortStrategy>(
                  value: Eventdatesort(),
                  child: Text('Date Sort'),
                ),
                PopupMenuItem<EventSortStrategy>(
                  value: EventNamesort(),
                  child: Text('Name Sort'),
                ),
              ],
            ),
            widget.isOwner
                ? IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EventCreationDialog(modelView: modelView,);
                          });
                      setState(() {});
                    },
                    tooltip: "Add Event",
                    icon: const Icon(Icons.add))
                : SizedBox.shrink(),
          ],
        ),
        body: FutureBuilder(
            future: modelView.getEventList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("error: ${snapshot.error}");
                }
                return SingleChildScrollView(
                    child: Center(child: Column(children: snapshot.data!)));
              }
              return Text("Hello");
            }));
  }
}
