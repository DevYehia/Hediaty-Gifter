import 'package:firebase_database/firebase_database.dart';
import 'package:hediaty/Models/DBManager.dart';

class Event{
  String eventID;
  String eventName;
  DateTime eventDate;
  String category;
  String location;
  String? description;
  String userID;
  
  Event({required this.eventID,
         required this.eventName,
         required this.eventDate,
         required this.category,
         required this.location,
         this.description,
         required this.userID});

  static Future<List<Event>> getAllEvents(String userID) async{
    List<Event> events = [];
    final db = await DBManager.getDataBase();
    List<Map> rawEvents = await db.rawQuery("SELECT * FROM EVENTS WHERE userID = \'$userID\'");
    print(rawEvents);
    for(final rawEvent in rawEvents){
      events.add(Event(eventID: rawEvent["ID"],
      eventName: rawEvent["name"],
      eventDate: DateTime.parse(rawEvent["date"]),
      category: rawEvent["category"],
      location: rawEvent["location"],
      description: rawEvent["description"],
      userID: rawEvent["userID"]));
    }
    //print("am i good");
    return events;    
  }


  static Future<void> insertEventLocal(Map<String, Object?> eventData) async{
    final db = await DBManager.getDataBase();
    await db.insert("EVENTS",eventData);
  }

  //function inserts event into firebase under eventID
  //if eventID is null, function uses push instead of update
  static Future<String> insertEventFireBase(Map<String, Object?> eventData) async{
    var eventListRef = FirebaseDatabase.instance.ref("Events");
    var newEventRef = eventListRef.push();
    var userRef = FirebaseDatabase.instance.ref("Users/${eventData["userID"]}");
    var userMap = (await userRef.get()).value as Map;

    await newEventRef.set(eventData);
    await userRef.update({"eventCount" : userMap["eventCount"] + 1});
    return newEventRef.key!;
  }


}