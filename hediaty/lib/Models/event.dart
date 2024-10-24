class Event{
  static int numEvents = 0;
  late int eventID;
  late String eventName;
  late DateTime eventDate;
  late String category;
  Event(String eventName, DateTime eventDate, String category){
    this.eventName = eventName;
    this.eventDate = eventDate;
    this.category = category;

    eventID = numEvents;
    numEvents++;
  }

}