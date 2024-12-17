
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Util/Gifts/GiftSortStrategy.dart';

class GiftNameSort implements GiftSortStrategy{
  @override
  List<GiftWidget> sort(List<GiftWidget> eventList) {
    eventList.sort((a,b) => a.gift.name.toLowerCase().compareTo(b.gift.name.toLowerCase()));
    return eventList;
  }
  
}