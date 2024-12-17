import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Enums/giftStatusEnum.dart';
import 'package:hediaty/Enums/giftStatusEnum.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';

class GiftStatusFilter implements GiftFilter{

  late GiftStatus selectedStatus;

  GiftStatusFilter(GiftStatus selectedStatus){
    this.selectedStatus = selectedStatus;
  }

  @override
  List<GiftWidget> filter(List<GiftWidget> originalList) {

    List<GiftWidget> newList = [];
      if (selectedStatus == GiftStatus.Pledged) {
        newList = originalList
            .where((giftWidg) =>
                giftWidg.gift.pledgerID != null)
            .toList();
      } else if (selectedStatus == GiftStatus.NotPledged) {
        newList = originalList
            .where((giftWidg) =>
                giftWidg.gift.pledgerID == null)
            .toList();
      }
    return newList;
  }
  
}