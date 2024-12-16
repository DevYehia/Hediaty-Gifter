import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Models/gift.dart';

class GiftModelView{


  List<GiftWidget>? allGiftList;
  List<GiftWidget> giftList = [];
  final Event event;
  final bool isOwner;
  final String userID;
  VoidCallback refreshCallback;
  GiftModelView({required this.isOwner, required this.event, required this.userID, required this.refreshCallback});


  Future<List<GiftWidget>> getGiftWidgets() async{

    late List<Gift> giftModelList;
    if(allGiftList == null){
      if(isOwner){
        giftModelList = await Gift.getAllGifts(event.eventID);
      }
      else{
        giftModelList = await Gift.getAllGiftsFirebase(event.firebaseID!);
      }
      allGiftList = giftModelList.map((gift) => GiftWidget(gift: gift, isOwner: isOwner,userID: userID,modelView: this,),).toList();
    }
    print("Gift Widgets are $giftList");
    giftList = allGiftList!;
    return giftList;
  }

  Future<void> addGift(
      String giftName,
      String giftCategory,
      String? giftDescription,
      double giftPrice) async {

    //insert Locally ONLY!!!
    int giftID = await Gift.insertGiftLocal(giftName, giftCategory, giftDescription, giftPrice, event.eventID);
    Gift addedGift = Gift(
        ID: giftID,
        name: giftName,
        category: giftCategory,
        description: giftDescription,
        price: giftPrice,
        isPledged: false,
        eventID: event.eventID
      ) ;
    allGiftList?.add(
        GiftWidget(gift: addedGift, isOwner: isOwner, userID: userID, modelView: this,)
    );
    refreshCallback();
  }

  Future<String> publishGift(Gift giftToPublish) async{

    String firebaseID = await Gift.insertGiftFireBase( giftToPublish.name, giftToPublish.category, giftToPublish.description ?? ""
    , giftToPublish.price, giftToPublish.ID, event.firebaseID!);

    Gift.setFirebaseIDinLocal(firebaseID, giftToPublish.ID);

    //set firebaseID in Gift Object in the widget
    allGiftList![allGiftList!.indexWhere(
            (giftWidg) => giftWidg.gift.ID == giftToPublish.ID)].gift.firebaseID = firebaseID;
    return firebaseID;
    
  }

  Future<void> removeGift(Gift giftToRemove) async{
    await Gift.deleteGiftLocal(giftToRemove.ID);
    if(giftToRemove.firebaseID != null){
      await Gift.deleteGiftFirebase(giftToRemove.firebaseID!);
      await Event.decrementGiftCounter(event.firebaseID!);
    }
    allGiftList!.removeWhere(
        (giftWidg) => giftWidg.gift.ID == giftToRemove.ID);
    refreshCallback();    
  }

  //removes it from firebase
  Future<void> hideGift(String firebaseID, int giftID) async{
      await Gift.deleteGiftFirebase(firebaseID);
      await Gift.setFirebaseIDinLocal(null, giftID);
      //String eventFirebaseID = await Event.getFirebaseID(localEventID);
      await Event.decrementGiftCounter(event.firebaseID!);
  }

}