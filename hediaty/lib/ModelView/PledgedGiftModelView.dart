import 'package:hediaty/CustomWidgets/pledgedGiftWidget.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';

class PledgedGiftModelView{

  List<PledgedGiftWidget>? pledgedGiftWidgetList;
  String userID;

  PledgedGiftModelView({required this.userID});

  Future<List<PledgedGiftWidget>> getPledgedGifts() async{

    if(pledgedGiftWidgetList == null){
      pledgedGiftWidgetList = [];
      List pledgedGiftList = await Gift.getPledgedGiftsByUserID(userID);
      for(Gift pledgedGift in pledgedGiftList){
        DateTime eventDate = (await Event.getEventByID(pledgedGift.eventID)).eventDate;
        pledgedGiftWidgetList!.add(PledgedGiftWidget(gift: pledgedGift, date: eventDate));
      }
    }
    return pledgedGiftWidgetList!;
  }

}