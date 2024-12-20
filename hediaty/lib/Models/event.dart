import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:intl/intl.dart';

class Event{
  int eventID;
  String eventName;
  DateTime eventDate;
  String category;
  String location;
  String? description;
  String userID;
  String? firebaseID;
  
  Event({required this.eventID,
         required this.eventName,
         required this.eventDate,
         required this.category,
         required this.location,
         this.description,
         required this.userID,
         this.firebaseID});

  static Future<List<Event>> getAllEvents(String userID) async{
    List<Event> events = [];
    final db = await DBManager.getDataBase();
    List<Map> rawEvents = await db.rawQuery("SELECT * FROM EVENTS WHERE userID = \'$userID\'");
    print("Before: $rawEvents");
    for(final rawEvent in rawEvents){
      events.add(Event(eventID: rawEvent["ID"],
      eventName: rawEvent["name"],
      eventDate: DateFormat("d/M/y").parse(rawEvent["date"]),
      category: rawEvent["category"],
      location: rawEvent["location"],
      description: rawEvent["description"],
      userID: rawEvent["userID"],
      firebaseID: rawEvent["firebaseID"]));
    }
    print("am i good");
    return events;    
  }


  static Future<List<Event>> getAllEventsFirebase(String userID) async{
    List<Event> events = [];
    //final db = await DBManager.getDataBase();
    //List<Map> rawEvents = await db.rawQuery("SELECT * FROM EVENTS WHERE userID = \'$userID\'");
    final ref = FirebaseDatabase.instance.ref("Events");
    DatabaseEvent fetchedEvents = await ref.orderByChild("userID").equalTo(userID).once();
    Map rawEvents;
    if(fetchedEvents.snapshot.value != null){
      rawEvents =  fetchedEvents.snapshot.value as Map;
    }
    else{
      rawEvents = {};
    }

    print("Events are $rawEvents");
    for(final rawEventKey in rawEvents.keys){
      Map rawEvent = rawEvents[rawEventKey];
      //print("raw event is $rawEvent");
      events.add(Event(eventID: rawEvent["localID"],
      eventName: rawEvent["name"],
      eventDate: DateFormat("d/M/y").parse(rawEvent["date"]),
      category: rawEvent["category"],
      location: rawEvent["location"],
      description: rawEvent["description"],
      userID: rawEvent["userID"],
      firebaseID: rawEventKey));
    }
    //print("am i good");
    return events;    
  }

  static Future<int> insertEventLocal(Map<String, Object?> eventData) async{
    final db = await DBManager.getDataBase();
    int eventID = await db.insert("EVENTS",eventData);
    return eventID;
  }

  //function inserts event into firebase under eventID
  //if eventID is null, function uses push instead of update
  static Future<String> insertEventFireBase(Map<String, Object?> eventData) async{
    eventData["giftCount"] = 0; //add gift count to map
    var eventListRef = FirebaseDatabase.instance.ref("Events");
    var newEventRef = eventListRef.push();
    var userRef = FirebaseDatabase.instance.ref("Users/${eventData["userID"]}");
    var userMap = (await userRef.get()).value as Map;


    //always make sure the eventCount update is second
    //because we listen to it to load new events
    await newEventRef.set(eventData);
    await userRef.update({"eventCount" : userMap["eventCount"] + 1});

    return newEventRef.key!;
  }

  static Future<Event> getEventByID(String inputEventID) async{
    var fetchedEvent = await FirebaseDatabase.instance.ref("Events/$inputEventID").get();
    Map rawEvent = fetchedEvent.value as Map;
    return Event(eventID: rawEvent["localID"],
      eventName: rawEvent["name"],
      eventDate: DateFormat("d/M/y").parse(rawEvent["date"]),
      category: rawEvent["category"],
      location: rawEvent["location"],
      description: rawEvent["description"],
      userID: rawEvent["userID"],
      firebaseID: fetchedEvent.key!);

  }

  static Future<void> removeEventLocal(int inputEventID) async{
    final db = await DBManager.getDataBase();
    await db.delete("Events",where: "ID = $inputEventID");

  }

  static Future<void> removeEventFirebase(String inputEventID) async{
    var eventRef = await FirebaseDatabase.instance.ref("Events/$inputEventID");
    await eventRef.remove();    
  }

  static Future<void> updateEventLocal(int eventID, String name, String date, String category, String location, String? description) async{
    final db = await DBManager.getDataBase();

    Map<String, Object?> eventMap = {
      "name" : name,
      "date" : date,
      "category" : category,
      "description" : description ?? "",
      "location" : location 
    };
    await db.update("Events", eventMap, where: "ID = $eventID");

  }

  static Future<void> updateEventFirebase(String eventID, String name, String date, String category, String location, String? description) async{

    final eventRef = FirebaseDatabase.instance.ref("Events/$eventID");

    Map<String, Object?> eventMap = {
      "name" : name,
      "date" : date,
      "category" : category,
      "description" : description ?? "",
      "location" : location,
    };

    await eventRef.update(eventMap);    
  }

  static Future<void> setFirebaseIDinLocal(String? firebaseID, int eventID) async{
    final db = await DBManager.getDataBase();
    await db.update("Events", {"firebaseID": firebaseID}, where: "ID = $eventID");        
  }

    static Future<void> decrementGiftCounter(String eventID) async{
      var eventRef = FirebaseDatabase.instance.ref("Events/$eventID");
      int giftCount = (await eventRef.child("giftCount").get()).value as int;
      await eventRef.update({
       "giftCount": giftCount - 1 
      });

    }

  static Future<String> getFirebaseID(int localID)async{
    final db = await DBManager.getDataBase();  
    Map<String, Object?> eventMap = (await db.rawQuery("SELECT firebaseID FROM EVENTS WHERE ID = $localID"))[0];
    return eventMap["firebaseID"] as String;  
  }

  static StreamSubscription<DatabaseEvent> attachListenerForEventCount(String userID, void Function(int) callback){


      //listen for Changes on event count
      var eventCountRef = FirebaseDatabase.instance.ref("Users/$userID/eventCount");
      var eventCountListener = eventCountRef.onValue.listen((updatedCount) { 
          print("Event Count Changed!!");
          callback(updatedCount.snapshot.value as int);
        }
      ,);    
      return eventCountListener;

  }

  static StreamSubscription<DatabaseEvent> attachListenerForEventChange(Event oldEvent, void Function(Event) callback){


      //listen for Changes on event count
      var eventRef = FirebaseDatabase.instance.ref("Events/${oldEvent.firebaseID!}");
      var eventListener = eventRef.onValue.listen((updatedEvent) { 

          Map rawEvent;
          Event newEvent;
          if(updatedEvent.snapshot.value != null){
            rawEvent = updatedEvent.snapshot.value as Map;
            newEvent = Event(eventID: rawEvent["localID"],
                            eventName: rawEvent["name"],
                            eventDate: DateFormat("d/M/y").parse(rawEvent["date"]),
                            category: rawEvent["category"],
                            location: rawEvent["location"],
                            description: rawEvent["description"],
                            userID: rawEvent["userID"],
                            firebaseID: updatedEvent.snapshot.key!);
            callback(newEvent);
          }

        }
      ,);    
      return eventListener;

  }
}