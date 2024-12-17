import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';

class EventPrivacyFilter implements EventFilter{

  late PrivacyStates privacyFilter;
  EventPrivacyFilter(PrivacyStates newPrivacyFilter){
    privacyFilter = newPrivacyFilter;
  }

  @override
  List<EventWidget> filter(List<EventWidget> originalList) {
    for(final eventWidg in originalList){
      print("FIrebase ID is ${eventWidg.event.firebaseID}");
    }
    List<EventWidget> newList = [];
    if(privacyFilter == PrivacyStates.Published){
      newList = originalList.where((eventWidg) => eventWidg.event.firebaseID != null && eventWidg.event.firebaseID != "").toList();
    }
    else if(privacyFilter == PrivacyStates.Hidden){
      newList = originalList.where((eventWidg) => eventWidg.event.firebaseID == null || eventWidg.event.firebaseID == "").toList();      
    }
    return newList;
  }
  
}