
import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Util/EventSortStrategy.dart';

class Eventdatesort implements EventSortStrategy{
  @override
  List<EventWidget> sort(List<EventWidget> eventList) {
    eventList.sort((a,b) => b.event.eventDate.compareTo(a.event.eventDate));    
    return eventList;
  }
  
}