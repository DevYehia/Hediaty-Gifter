import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';

class EventCategoryFilter implements EventFilter{

  late EventCategories selectedCat;

  EventCategoryFilter(EventCategories selectedCat){
    this.selectedCat = selectedCat;
  }
  @override
  List<EventWidget> filter(List<EventWidget> originalList) {
    List<EventWidget>  newList = 
    originalList.where((eventWidg) =>
              eventWidg.event.category == selectedCat.name)
          .toList();
    return newList;
  }
  
}