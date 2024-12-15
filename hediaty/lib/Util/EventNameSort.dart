
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Util/EventSortStrategy.dart';

class EventNamesort implements EventSortStrategy{
  @override
  List<EventWidget> sort(List<EventWidget> eventList) {
    eventList.sort((a,b) => a.event.eventName.toLowerCase().compareTo(b.event.eventName.toLowerCase()));
    return eventList;
  }
  
}