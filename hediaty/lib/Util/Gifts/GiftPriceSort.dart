import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Util/Gifts/GiftSortStrategy.dart';

class GiftPriceSort implements GiftSortStrategy{
  @override
  List<GiftWidget> sort(List<GiftWidget> giftList) {
    giftList.sort((a, b) => a.gift.price.compareTo(b.gift.price),);
    return giftList;
  }
  
}