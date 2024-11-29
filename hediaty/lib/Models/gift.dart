import 'package:firebase_database/firebase_database.dart';
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

}