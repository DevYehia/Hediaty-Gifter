import 'package:hediaty/CustomWidgets/eventWidget.dart';

abstract class EventFilter{



  List<EventWidget> filter(List<EventWidget> originalList);
}