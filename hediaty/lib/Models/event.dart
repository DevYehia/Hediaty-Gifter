import 'package:hediaty/Models/DBManager.dart';

class Event{
  int eventID;
  String eventName;
  DateTime eventDate;
  String category;
  String location;
  String? description;
  int userID;
  
  Event({required this.eventID,
         required this.eventName,
         required this.eventDate,
         required this.category,
         required this.location,
         this.description,
         required this.userID});

  static Future<List<Event>> getAllEvents(int userID) async{
    List<Event> events = [];
    final db = await DBManager.getDataBase();
    List<Map> rawEvents = await db.rawQuery("SELECT * FROM EVENTS WHERE userID = $userID");
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
    print("am i good");
    return events;    
  }


}