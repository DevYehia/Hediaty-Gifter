import 'package:hediaty/CustomWidgets/eventWidget.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';

class GiftPrivacyFilter implements GiftFilter{

  late PrivacyStates privacyFilter;
  GiftPrivacyFilter(PrivacyStates newPrivacyFilter){
    privacyFilter = newPrivacyFilter;
  }

  @override
  List<GiftWidget> filter(List<GiftWidget> originalList) {

    List<GiftWidget> newList = [];
    if(privacyFilter == PrivacyStates.Published){
      newList = originalList.where((eventWidg) => eventWidg.gift.firebaseID != null && eventWidg.gift.firebaseID != "").toList();
    }
    else if(privacyFilter == PrivacyStates.Hidden){
      newList = originalList.where((eventWidg) => eventWidg.gift.firebaseID == null || eventWidg.gift.firebaseID == "").toList();      
    }
    return newList;
  }
  
}