import 'package:hediaty/CustomWidgets/eventWidget.dart';

abstract class EventSortStrategy{
  List<EventWidget> sort(List<EventWidget> eventList);
}