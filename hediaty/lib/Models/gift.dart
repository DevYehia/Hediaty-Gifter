import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/Models/DBManager.dart';

class Gift{
  int ID;
  String name;
  String? description;
  String category;
  double price;
  bool isPledged;
  dynamic eventID; //dynamic because it can be int (local ID) or String (Firebase ID)
  String? firebaseID;
  String? pledgerID;
  Gift({required this.ID,
        required this.name,
        this.description, 
        required this.category,
        required this.price,
        required this.isPledged,
        required this.eventID,
        this.pledgerID,
        this.firebaseID
        });


  static Future<List<Gift>> getAllGifts(int eventID) async{
    List<Gift> gifts = [];
    final db = await DBManager.getDataBase();
    List<Map> rawGifts = await db.rawQuery("SELECT * FROM GIFTS WHERE eventID = $eventID");
    print(rawGifts);
    for(final rawGift in rawGifts){
      String? rawFirebaseID = rawGift["firebaseID"];
      String? firebaseID = (rawFirebaseID == "" || rawFirebaseID == null) ? null : rawFirebaseID; 

      gifts.add(Gift(ID: rawGift["ID"],
      name: rawGift["name"],
      price: rawGift["price"],
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"] == "" ? null : rawGift["pledgerID"],
      firebaseID: firebaseID));
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
    Map rawGifts;
    if(fetchedGifts.snapshot.value != null){
      rawGifts = fetchedGifts.snapshot.value as Map;    
    }
    else{
      rawGifts = {};
    }
    print(rawGifts);
    for(final rawGiftKey in rawGifts.keys){
      Map rawGift = rawGifts[rawGiftKey];
      print("Result: ${rawGift["localID"] is int}");
      gifts.add(Gift(ID: rawGift["localID"],
      name: rawGift["name"],
      price: rawGift["price"].toDouble(),
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"] == "" ? null : rawGift["pledgerID"],
      firebaseID: rawGiftKey));
    }
    print("Gifts!!!");
    return gifts;    
  }


  static Future<int> insertGiftLocal(int? ID, String name, String category, String? description, double price, int eventID) async{
    Map<String, Object?> giftData = {
      "name" : name,
      "description" : description,
      "category" : category,
      "price" : price,
      "isPledged" : 0,
      "eventID" : eventID,
      "pledgerID" : ""
    };
    if(ID != null) giftData["ID"] = ID;



    final db = await DBManager.getDataBase();
    int giftID = await db.insert("GIFTS",giftData);
    return giftID;    
  }

  //function inserts gift into firebase and returns the gift ID
  static Future<String> insertGiftFireBase(String name, String category, String? description, double price, int giftLocalID, String eventFirebaseID) async{

    Map<String, Object?> giftData = {
      "name" : name,
      "description" : description,
      "category" : category,
      "price" : price,
      "isPledged" : 0,
      "eventID" : eventFirebaseID,
      "pledgerID" : "",
      "localID" : giftLocalID
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

  static Future<void> updatePledgerLocal(String newPledgerID, int giftID) async{
    final db = await DBManager.getDataBase();
    await db.update("Gifts",{"pledgerID" : newPledgerID}, where: "ID =$giftID");
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

  static StreamSubscription<DatabaseEvent> attachListenerForGiftCount(String eventID, void Function(int) callback){


      //listen for Pledging on Gift with giftID
      var giftCountRef = FirebaseDatabase.instance.ref("Events/$eventID/giftCount");
      var giftPledgeListener = giftCountRef.onValue.listen((event) { 
          print("Got the Gift Count!");
          callback(event.snapshot.value as int);
        }
      ,);  
      return giftPledgeListener;

  }

  static Future<List<Gift>> getPledgedGiftsByUserID(String userID) async{
    List<Gift> pledgedGifts = [];
    final ref = FirebaseDatabase.instance.ref("Gifts");
    DatabaseEvent fetchedGifts = await ref.orderByChild("pledgerID").equalTo(userID).once();
    Map fetchedGiftsMap = (fetchedGifts.snapshot.value != null)? fetchedGifts.snapshot.value as Map : {};
    for(final giftKey in fetchedGiftsMap.keys){
      Map rawGift = fetchedGiftsMap[giftKey];

      pledgedGifts.add(Gift(ID: rawGift["localID"],
      name: rawGift["name"],
      price: rawGift["price"].toDouble(),
      category: rawGift["category"],
      description: rawGift["description"],
      isPledged: rawGift["isPledged"] == 0 ? false : true,
      eventID: rawGift["eventID"],
      pledgerID: rawGift["pledgerID"] == "" ? null : rawGift["pledgerID"],
      firebaseID: giftKey));
    }
    print("Hello");
    return pledgedGifts;

  } 

  static Future<void> unpledgeGift(String giftID) async{
    var giftRef = FirebaseDatabase.instance.ref("Gifts/$giftID");
    await giftRef.update({"pledgerID" : ""});    
  }

  static Future<void> deleteGiftLocal(int giftID) async{
    final db = await DBManager.getDataBase();
    await db.delete("Gifts",where: "ID = $giftID");    

  }

  static Future<void> deleteGiftFirebase(String giftID) async{
    var giftRef = await FirebaseDatabase.instance.ref("Gifts/$giftID");
    await giftRef.remove();    
  }

  static Future<void> setFirebaseIDinLocal(String? firebaseID, int giftID) async{
    final db = await DBManager.getDataBase();
    await db.update("Gifts", {"firebaseID": firebaseID}, where: "ID = $giftID");        
  }

  static Future<void> updateGiftLocal(Gift newGift) async{
    final db = await DBManager.getDataBase();
    Map<String, Object?> giftData = {
      "name" : newGift.name,
      "description" : newGift.description??"",
      "category" : newGift.category,
      "price" : newGift.price
    };
    await db.update("Gifts",giftData,where: "ID = ${newGift.ID}");

  }

  static Future<void> updateGiftFirebase(Gift newGift) async{
    final GiftRef = FirebaseDatabase.instance.ref("Gifts/${newGift.firebaseID}");
    Map<String, Object?> giftData = {
      "name" : newGift.name,
      "description" : newGift.description??"",
      "category" : newGift.category,
      "price" : newGift.price
    };
    await GiftRef.update(giftData);

  }

}


