import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';
import 'package:hediaty/Util/Gifts/GiftSortStrategy.dart';

class GiftModelView{


  List<GiftWidget>? allGiftList;
  List<GiftWidget> giftList = [];
  List<GiftFilter> filters = [];
  GiftSortStrategy? selectedSort;
  final Event event;
  final bool isOwner;
  final String userID;
  VoidCallback refreshCallback;
  StreamSubscription<DatabaseEvent>? giftCountListener;
  GiftModelView({required this.isOwner, required this.event, required this.userID, required this.refreshCallback});


  void setFilters(List<GiftFilter> newFilters){
    filters = newFilters;
  }

  void setSort(GiftSortStrategy newSort){
    selectedSort = newSort;
  }

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

    if(event.firebaseID != null){ //attach listener for published Event ONLY
      giftCountListener = Gift.attachListenerForGiftCount(event.firebaseID!, compareGiftCountWithRemote);
    }
    print("Gift Widgets are $giftList");
    giftList = allGiftList!;
    for(final filter in filters){
      giftList = filter.filter(giftList);
    }
    if(selectedSort != null){
      giftList = selectedSort!.sort(giftList);
    }

    return giftList;
  }

  Future<void> addGift(
      String giftName,
      String giftCategory,
      String? giftDescription,
      double giftPrice) async {

    //insert Locally ONLY!!!
    int giftID = await Gift.insertGiftLocal(null, giftName, giftCategory, giftDescription, giftPrice, event.eventID);
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

  Future<void> editGift(Gift newGift) async{
    
    await Gift.updateGiftLocal(newGift);

    if(newGift.firebaseID != null){
      await Gift.updateGiftFirebase(newGift);
    }

    //update widget and refresh
    allGiftList![allGiftList!.indexWhere(
            (giftWidg) => giftWidg.gift.ID == newGift.ID)]
        .gift = newGift;
    refreshCallback();    
  }
  //removes it from firebase
  Future<void> hideGift(String firebaseID, int giftID) async{
      await Gift.deleteGiftFirebase(firebaseID);
      await Gift.setFirebaseIDinLocal(null, giftID);
      //String eventFirebaseID = await Event.getFirebaseID(localEventID);
      await Event.decrementGiftCounter(event.firebaseID!);
  }

  void compareGiftCountWithRemote(int newGiftCount) async {
    //user added an event

    if (!isOwner) {
      if (newGiftCount > allGiftList!.length) {
        print("Am called");
        allGiftList = null;
        refreshCallback();
        //if (addedUIUpdate != null) addedUIUpdate!();
      }

      //user deleted an event
      else if (newGiftCount < allGiftList!.length) {
        print("Am called");
        allGiftList = null;
        refreshCallback();
        //if (removedUIUpdate != null) removedUIUpdate!();
      }
    } else { //sync events from firebase to local, if there are extra gifts
      //if listener is null --> sync is done
      if (giftCountListener != null && newGiftCount > allGiftList!.length) {

        //can't be null, since listener attached only to published events
        List<Gift> rawGiftList = await Gift.getAllGiftsFirebase(event.firebaseID!); 
        for (final rawGift in rawGiftList) {
            await Gift.insertGiftLocal(rawGift.ID, rawGift.name, rawGift.category, rawGift.description, rawGift.price,
            event.eventID);
            await Gift.setFirebaseIDinLocal(rawGift.firebaseID, rawGift.ID);
            if(rawGift.pledgerID != null){
              await Gift.updatePledgerLocal(rawGift.pledgerID!, rawGift.ID);
            }
        }
        allGiftList = null;
        refreshCallback();
      }
        //after finishing sync cancel the listener
        await giftCountListener!.cancel();
        giftCountListener = null;
        print("Cancelled successfully");
    }
  }

}