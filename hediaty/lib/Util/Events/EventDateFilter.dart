import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';

class EventDateFilter implements EventFilter{

  late EventStatus selectedStatus;

  EventDateFilter(EventStatus selectedStatus){
    this.selectedStatus = selectedStatus;
  }

  @override
  List<EventWidget> filter(List<EventWidget> originalList) {

    List<EventWidget> newList = [];
      if (selectedStatus == EventStatus.Past) {
        newList = originalList
            .where((eventWidg) =>
                eventWidg.event.eventDate.isBefore(DateTime.now()))
            .toList();
      } else if (selectedStatus == EventStatus.Upcoming) {
        newList = originalList
            .where((eventWidg) =>
                eventWidg.event.eventDate.isAfter(DateTime.now()))
            .toList();
      }
    return newList;
  }
  
}