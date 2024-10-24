

import 'package:hediaty/Models/event.dart';

class Friend{
  final String friendName;
  final List<Event> events  = <Event>[];
  Friend({required this.friendName});

  //todo
  //should return all events of friend to be rendered
  void getEvents(){}
}