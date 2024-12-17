import 'package:hediaty/CustomWidgets/eventWidget.dart';

abstract class EventFilterStrategy {

  List<EventWidget> filter(List<EventWidget> eventList);
}