import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/Models/DBManager.dart';

class Gift{
  String ID;
  String name;
  String? description;
  String category;
  double price;
  bool isPledged;
  String eventID;
  String? pledgerID;
  Gift({required this.ID,
        required this.name,
        this.description, 
        required this.category,
        required this.price,
        required this.isPledged,
        required this.eventID,
        this.pledgerID
        });


  static Future<List<Gift>> getAllGifts(String eventID) async{
    List<Gift> gifts = [];
    final db = await DBManager.getDataBase();
    List<Map> rawGifts = await db.rawQuery("SELECT * FROM GIFTS WHERE eventID = '$eventID'");
    print(rawGifts);
    for(final rawGift in rawGifts){
      gifts.add(Gift(ID: rawGift["ID"],
      name: rawGift["name"],
      price: rawGift["price"],
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"]));
    }
    print("Gifts!!!");
    return gifts;    
  }

  static Future<List<Gift>> getAllGiftsFirebase(String eventID) async{
    List<Gift> gifts = [];
    final db = await DBManager.getDataBase();
    //ist<Map> rawGifts = await db.rawQuery("SELECT * FROM GIFTS WHERE eventID = '$eventID'");
    final ref = FirebaseDatabase.instance.ref("Gifts");
    DatabaseEvent fetchedGifts = await ref.orderByChild("eventID").equalTo(eventID).once();
    Map rawGifts = fetchedGifts.snapshot.value as Map;    
    print(rawGifts);
    for(final rawGiftKey in rawGifts.keys){
      Map rawGift = rawGifts[rawGiftKey];
      gifts.add(Gift(ID: rawGiftKey,
      name: rawGift["name"],
      price: rawGift["price"].toDouble(),
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"]));
    }
    print("Gifts!!!");
    return gifts;    
  }


  static Future<void> insertGiftLocal(String ID,String name, String category, String? description, double price, String eventID) async{
    Map<String, Object?> giftData = {
      "ID" : ID,
      "name" : name,
      "description" : description,
      "category" : category,
      "price" : price,
      "isPledged" : 0,
      "eventID" : eventID,
      "pledgerID" : ""
    };



    final db = await DBManager.getDataBase();
    await db.insert("GIFTS",giftData);    
  }

  //function inserts gift into firebase and returns the gift ID
  static Future<String> insertGiftFireBase(String name, String category, String? description, double price, String eventID) async{

    Map<String, Object?> giftData = {
      "name" : name,
      "description" : description,
      "category" : category,
      "price" : price,
      "isPledged" : 0,
      "eventID" : eventID,
      "pledgerID" : ""
    };
    var giftListRef = FirebaseDatabase.instance.ref("Gifts");
    var newGiftRef = giftListRef.push();
    var eventRef = FirebaseDatabase.instance.ref("Events/${giftData["eventID"]}");
    var eventMap = (await eventRef.get()).value as Map;

    await newGiftRef.set(giftData);
    await eventRef.update({"giftCount" : eventMap["giftCount"] + 1});
    return newGiftRef.key!;
  }

  static Future<void> pledgeFriendGift(String giftID, String userID) async{
    var giftRef = FirebaseDatabase.instance.ref("Gifts/$giftID");
    final db = await DBManager.getDataBase();
    await giftRef.update(
      {
        "isPledged" : 1,
        "pledgerID" : userID
      }
    );
    //db.update("Gifts",{"pledge"})
  }

  static Future<void> updatePledgerLocal(String newPledgerID, String giftID) async{
    final db = await DBManager.getDataBase();
    await db.update("Gifts",{"pledgerID" : newPledgerID}, where: "ID ='$giftID'");
  }

  static Future<void> syncFirebaseWithLocalGifts() async{
    final db = await DBManager.getDataBase();
    List<Map> localGiftsData = await db.rawQuery("SELECT ID, pledgerID FROM GIFTS");
    final giftsRef = FirebaseDatabase.instance.ref("Gifts");
    for (final localGiftData in localGiftsData){
      Map giftDataMap = (await giftsRef.child(localGiftData["ID"]).get()).value as Map;
      if (giftDataMap["pledgerID"] != localGiftData["pledgerID"]){ //someone pledged a gift, update that locally
        await db.update("Gifts", {"pledgerID" : giftDataMap["pledgerID"]}, where: "ID ='${localGiftData["ID"]}'");
      }
    }

  }


  static StreamSubscription<DatabaseEvent> attachListenerForPledge(String giftID, void Function(String) callback){


      //listen for Pledging on Gift with giftID
      var giftPledgerRef = FirebaseDatabase.instance.ref("Gifts/$giftID/pledgerID");
      var giftPledgeListener = giftPledgerRef.onValue.listen((event) { 
          print("I am called");
          callback(event.snapshot.value as String);
        }
      ,);    
      return giftPledgeListener;

  }

  static Future<List<Gift>> getPledgedGiftsByUserID(String userID) async{
    List<Gift> pledgedGifts = [];
    final ref = FirebaseDatabase.instance.ref("Gifts");
    DatabaseEvent fetchedGifts = await ref.orderByChild("pledgerID").equalTo(userID).once();
    print("Fetched Gifts are ${fetchedGifts.snapshot.value}");
    Map fetchedGiftsMap = fetchedGifts.snapshot.value as Map;
    print("Fetched Gifts are $fetchedGiftsMap");
    for(final giftKey in fetchedGiftsMap.keys){
      Map rawGift = fetchedGiftsMap[giftKey];

      pledgedGifts.add(Gift(ID: rawGift["ID"],
      name: rawGift["name"],
      price: rawGift["price"],
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"]));
    }
    return pledgedGifts;

  } 


}


