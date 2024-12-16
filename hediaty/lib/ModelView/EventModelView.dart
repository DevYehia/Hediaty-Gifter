import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/Util/EventSortStrategy.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class EventModelView {
  List<EventWidget> eventList = []; //event Widget List after filters
  List<EventWidget>? allEventList; //all event widgets regardless of filters
  DateFormat dateFormatter = DateFormat("d/M/y");
  //First Filter is Category Filter
  //second filter is Status Filter
  List<dynamic> selectedFilters = [null, null];
  EventSortStrategy? selectedSort;
  String userID;
  bool isOwner;
  VoidCallback refreshCallback;
  VoidCallback? addedUIUpdate;
  VoidCallback? editedUIUpdate;
  VoidCallback? removedUIUpdate;  

  EventModelView(
      {required this.userID,
      required this.isOwner,
      required this.refreshCallback,
      this.addedUIUpdate,
      this.editedUIUpdate,
      this.removedUIUpdate});

  //change filters applied to eventList
  //called when user changes filters
  void setFilters(List<dynamic> newFilters) {
    selectedFilters = newFilters;
  }

  void setSort(EventSortStrategy newSort) {
    selectedSort = newSort;
  }

  //get eventWidgets for events based on userID
  Future<List<EventWidget>> getEventList() async {
    if (allEventList == null) {
      print("fetched Events from Repos");
      late List<Event> rawEventList;
      if (isOwner) {
        rawEventList = await Event.getAllEvents(userID);
      } else {
        rawEventList = await Event.getAllEventsFirebase(userID);
      }
      allEventList = rawEventList
          .map(
            (event) => EventWidget(
              event: event,
              isOwner: isOwner,
              modelView: this,
            ),
          )
          .toList();
    }
    EventCategories? selectedFilterCat;
    EventStatus? selectedFilterStatus;
    if (selectedFilters.length != 0) {
      selectedFilterCat = selectedFilters[0];
      selectedFilterStatus = selectedFilters[1];
    }
    //filter category
    if (selectedFilterCat != null) {
      eventList = allEventList!
          .where((eventWidg) =>
              eventWidg.event.category == selectedFilterCat!.name)
          .toList();
    } else {
      eventList = allEventList!;
    }

    //filter status
    if (selectedFilterStatus != null) {
      if (selectedFilterStatus == EventStatus.Past) {
        eventList = eventList
            .where((eventWidg) =>
                eventWidg.event.eventDate.isBefore(DateTime.now()))
            .toList();
      } else if (selectedFilterStatus == EventStatus.Upcoming) {
        eventList = eventList
            .where((eventWidg) =>
                eventWidg.event.eventDate.isAfter(DateTime.now()))
            .toList();
      }
    }
    if (selectedSort != null) {
      eventList = selectedSort!.sort(eventList);
    }

    //attach listener for updates in event Count
    if (!isOwner) {
      Event.attachListenerForEventCount(userID, compareEventCountWithRemote);
    }

    return eventList;
  }

  Future<void> addEvent(
      String eventName,
      String eventDate,
      String eventCategory,
      String? eventDescription,
      String eventLocation) async {
    Map<String, Object?> eventData = {
      'name': eventName,
      'date': eventDate, //To Do --> Add proper date
      'category': eventCategory,
      'location': eventLocation,
      'description': eventDescription ?? "",
      'userID': UserModel.getLoggedUserID()
    };
    print("Data Map is $eventData");

    //insert Locally ONLY!!!
    int eventID = await Event.insertEventLocal(eventData);
    Event addedEvent = Event(
        eventID: eventID,
        eventDate: DateFormat("d/M/y").parse(eventDate),
        eventName: eventName,
        category: eventCategory,
        location: eventLocation,
        userID: UserModel.getLoggedUserID());
    allEventList?.add(
        EventWidget(event: addedEvent, isOwner: isOwner, modelView: this));
    refreshCallback();
  }

  Future<String> publishEvent(Event eventToPublish) async {
    Map<String, Object?> eventData = {
      'name': eventToPublish.eventName,
      'date': dateFormatter.format(eventToPublish.eventDate),
      'category': eventToPublish.category,
      'location': eventToPublish.location,
      'description': eventToPublish.description ?? "",
      'userID': UserModel.getLoggedUserID(),
      'localID': eventToPublish.eventID
    };

    String firebaseID = await Event.insertEventFireBase(eventData);
    await Event.setFirebaseIDinLocal(firebaseID, eventToPublish.eventID);

    //set firebaseID in Event Object in the widget
    //allEventList![allEventList!.indexWhere(
    //(eventWidg) => eventWidg.event.eventID == eventToPublish.eventID)].event.firebaseID = firebaseID;
    return firebaseID;
  }

  Future<void> editEvent(
      String eventName,
      String eventDate,
      String eventCategory,
      String? eventDescription,
      String eventLocation,
      Event eventToModify) async {
    Map<String, Object?> eventData = {
      'name': eventName,
      'date': eventDate, //To Do --> Add proper date
      'category': eventCategory,
      'location': eventLocation,
      'description': eventDescription,
      'userID': UserModel.getLoggedUserID()
    };
    print("Data Map is $eventData");

    await Event.updateEventLocal(eventToModify.eventID, eventName, eventDate,
        eventCategory, eventLocation, eventDescription);

    await Event.updateEventFirebase(eventToModify.firebaseID!, eventName,
        eventDate, eventCategory, eventLocation, eventDescription ?? "");

    //modify event object
    eventToModify.eventName = eventName;
    eventToModify.eventDate = DateFormat("d/M/y").parse(eventDate);
    eventToModify.category = eventCategory;
    eventToModify.location = eventLocation;
    eventToModify.description = eventDescription;

    //update widget and refresh
    allEventList![allEventList!.indexWhere(
            (eventWidg) => eventWidg.event.eventID == eventToModify.eventID)]
        .event = eventToModify;
  }

  Future<void> removeEvent(Event eventToRemove) async {
    //TODO Remove all related gifts

    await Event.removeEventLocal(eventToRemove.eventID);
    if (eventToRemove.firebaseID != null) {
      await Event.removeEventFirebase(eventToRemove.firebaseID!);
      await UserModel.decrementEventCounter(eventToRemove.userID);
    }
    allEventList!.removeWhere(
        (eventWidg) => eventWidg.event.eventID == eventToRemove.eventID);
    refreshCallback();
  }

  //removes it from firebase
  Future<void> hideEvent(String firebaseID, String userID, int eventID) async {
    //TODO Handle gift hiding or stop hiding event if some gifts are public

    await Event.removeEventFirebase(firebaseID!);
    await UserModel.decrementEventCounter(userID);
    await Event.setFirebaseIDinLocal(null, eventID);
  }

  void compareEventCountWithRemote(int newEventCount) {
    //user added an event
    print("New Event Count is $newEventCount");
    if (newEventCount > allEventList!.length) {
      print("Am called");
      allEventList = null;
      refreshCallback();
      if(addedUIUpdate != null) addedUIUpdate!();
    }

    //user deleted an event
    else if (newEventCount < allEventList!.length) {
      print("Am called");
      allEventList = null;
      refreshCallback();
      if(removedUIUpdate != null) removedUIUpdate!();
    }
  }

  void listenForEventChange(Event oldEvent) {
    var eventChangeListener =
        Event.attachListenerForEventChange(oldEvent, updateEvent);
  }

  void updateEvent(Event newEvent) {
    Event oldEvent = allEventList![allEventList!.indexWhere(
            (eventWidg) => eventWidg.event.firebaseID == newEvent.firebaseID)]
        .event;

    //update if widgets mismatch
    if(!compareEvents(oldEvent, newEvent)){
      //update widget and refresh
      allEventList![allEventList!.indexWhere(
              (eventWidg) => eventWidg.event.firebaseID == newEvent.firebaseID)]
          .event = newEvent;

      refreshCallback();
      if(editedUIUpdate != null) editedUIUpdate!();
    }
  }

  bool compareEvents(Event event1, Event event2){

    if(event1.eventName != event2.eventName ||
       event1.eventDate != event2.eventDate ||
       event1.category != event2.category ||
       event1.description != event2.description ||
       event1.location != event2.location){
        return false;
       }

    return true;

  }
}
